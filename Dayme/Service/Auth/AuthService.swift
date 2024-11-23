//
//  AuthService.swift
//  Dayme
//
//  Created by 정동천 on 11/5/24.
//

import Foundation
import UIKit.UIViewController
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import CryptoKit

class AuthService: NSObject {
    
    private weak var presenter: UIViewController!
    
    private let network = Network()
    
    private var kakaoContinuation: CheckedContinuation<KakaoSDKAuth.OAuthToken, Error>?
    private var appleContinuation: CheckedContinuation<ASAuthorization, Error>?
    
    private var currentNonce: String?
    
    
    @MainActor
    func getSocialIdToken(_ provider: OAuthProvider, presenter: UIViewController!) async throws -> String {
        self.presenter = presenter
        
        return switch provider {
        case .google: try await loginWithGoogle()
        case .kakao: try await loginWithKakao()
        case .apple: try await loginWithApple()
        }
    }
    
    @MainActor
    @discardableResult
    func loginWithSocial(_ provider: OAuthProvider, idToken: String) async throws -> OAuthToken {
        let endpoint = Endpoint(
            method: .post,
            baseUrl: Env.serverBaseUrl,
            path: "/auth/loginBySns",
            params: ["socialLoginType": provider.code]
        ).withAuthorization(idToken)
        
        let response: LoginResponse = try await network.request(endpoint)
        let oAuthToken = response.toDomain()
        
        saveToken(oAuthToken)
        
        return oAuthToken
    }
    
    @MainActor
    @discardableResult
    func login(email: String, password: String) async throws -> OAuthToken {
        let endpoint = Endpoint(
            method: .post,
            baseUrl: Env.serverBaseUrl,
            path: "/auth/login",
            params: ["email": email, "password": password]
        )
        
        let response: LoginResponse = try await network.request(endpoint)
        let oAuthToken = response.toDomain()
        
        saveToken(oAuthToken)
        
        return oAuthToken
    }
    
    @MainActor
    func signupWithSocial(_ provider: OAuthProvider, nickname: String, idToken: String) async throws {
        Logger.debug("Bearer \(idToken)")
        let endpoint = Endpoint(
            method: .post,
            baseUrl: Env.serverBaseUrl,
            path: "/auth/signupBySns",
            params: ["socialLoginType": provider.code, "nickname": nickname]
        ).withAuthorization(idToken)
        
        try await network.request(endpoint)
    }
    
    @MainActor
    func signup(email: String, password: String, nickname: String) async throws {
        let endpoint = Endpoint(
            method: .post,
            baseUrl: Env.serverBaseUrl,
            path: "/auth/signup",
            params: ["email": email, "password": password, "nickname": nickname]
        )
        try await network.request(endpoint)
    }
    
}

// MARK: - 소셜 로그인

private extension AuthService {
    
    @MainActor
    func loginWithGoogle() async throws -> String {
        let auth = GIDSignIn.sharedInstance
        auth.configuration = GIDConfiguration(clientID: Env.firebaseClientId)
        
        do {
            let result = try await auth.signIn(withPresenting: presenter)
            if let googleIdToken = result.user.idToken?.tokenString {
                let accessToken = result.user.accessToken.tokenString
                let credential = GoogleAuthProvider.credential(withIDToken: googleIdToken,
                                                               accessToken: accessToken)
                return try await getFirebaseIdToken(with: credential)
            }
        } catch GIDSignInError.canceled {
            throw AuthError.canceled
        } catch {
            throw error
        }
        
        throw AuthError.emptySocialToken
    }
    
    @MainActor
    func loginWithApple() async throws -> String {
        let nonce = generateRandomeNonce()
        currentNonce = nonce
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        let authorization = try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.appleContinuation = continuation
            controller.performRequests()
        }
        
        guard let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = appleCredential.identityToken,
              let idToken = String(data: identityToken, encoding: .utf8) else {
            throw AuthError.emptySocialToken
        }
        
        let credential = FirebaseAuth.OAuthProvider.appleCredential(
            withIDToken: idToken,
            rawNonce: currentNonce,
            fullName: appleCredential.fullName
        )
        
        return try await getFirebaseIdToken(with: credential)
    }
    
    @MainActor
    func loginWithKakao() async throws -> String {
        KakaoSDK.initSDK(appKey: Env.kakakoAppKey)
        
        let oAuthToken = try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.kakaoContinuation = continuation
            
            let auth = UserApi.shared
            if UserApi.isKakaoTalkLoginAvailable() {
                // '카카오톡'으로 로그인
                auth.loginWithKakaoTalk { result, error in
                    self?.kakaoLoginHandler(result, error)
                }
            } else {
                // '카카오 계정'으로 로그인
                auth.loginWithKakaoAccount { result, error in
                    self?.kakaoLoginHandler(result, error)
                }
            }
        }
        
        return oAuthToken.accessToken
    }
    
}

private extension AuthService {
    // 파이어베이스
    func getFirebaseIdToken(with credential: AuthCredential) async throws -> String {
        let authResult = try await FirebaseAuth.Auth.auth().signIn(with: credential)
        return try await authResult.user.getIDTokenResult(forcingRefresh: true).token
    }
    
    // 카카오
    func kakaoLoginHandler(_ result: KakaoSDKAuth.OAuthToken?, _ error: Error?) {
        if let result {
            kakaoContinuation?.resume(returning: result)
            kakaoContinuation = nil
            return
        }
        
        kakaoContinuation?.resume(throwing: error ?? AuthError.failedKakaoLogin)
        kakaoContinuation = nil
    }
    
    /// 재전송 공격 방지 목적
    /// https://firebase.google.com/docs/auth/ios/apple?hl=ko
    func generateRandomeNonce(length: Int = 32) -> String {
        precondition(length > 0)
        
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    /// nonce SHA256 해싱
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap({ String(format: "%02x", $0) }).joined()
        return hashString
    }
    
    func saveToken(_ oAuthToken: OAuthToken) {
        Keychain.create(key: Env.Keychain.accessTokenKey, token: oAuthToken.accessToken)
        Keychain.create(key: Env.Keychain.refreshTokenKey, token: oAuthToken.refreshToken)
    }
    
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AuthService: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        presenter.view.window ?? UIWindow()
    }
    
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        if case ASAuthorizationError.canceled = error {
            appleContinuation?.resume(throwing: AuthError.canceled)
        } else {
            appleContinuation?.resume(throwing: error)
        }
        appleContinuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        appleContinuation?.resume(returning: authorization)
        appleContinuation = nil
    }
    
}
