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

class AuthService: NSObject {
    
    private weak var presenter: UIViewController!
    
    private let network = Network()
    
    private var kakaoContinuation: CheckedContinuation<KakaoSDKAuth.OAuthToken, Error>?
    private var appleContinuation: CheckedContinuation<ASAuthorization, Error>?
    
    @MainActor
    func loginWithSocial(_ provider: OAuthProvider, presenter: UIViewController!) async throws {
        self.presenter = presenter
        
        let idToken = switch provider {
        case .google: try await loginWithGoogle()
        case .kakao: try await loginWithKakao()
        case .apple: try await loginWithApple()
        }
        
        try await loginSocial(provider, token: idToken)
    }
    
}

// MARK: - 소셜 로그인

private extension AuthService {
    
    struct LoginResponse: Decodable {
        let accessToken: String
        let refreshToken: String
    }
    
    func loginSocial(_ provider: OAuthProvider, token: String) async throws {
        // 서버 로그인
        let response: LoginResponse = try await network.request(
            .post,
            baseUrl: Env.serverBaseUrl,
            path: "/auth/loginBySns",
            params: ["socialLoginType": provider.rawValue],
            headers: ["Authorization": "Bearer \(token)"]
        )
        
        // 키체인 토큰 저장
        Keychain.create(key: Env.Keychain.accessTokenKey, token: response.accessToken)
        Keychain.create(key: Env.Keychain.refreshTokenKey, token: response.refreshToken)
    }
    
    @MainActor
    func loginWithGoogle() async throws -> String {
        let auth = GIDSignIn.sharedInstance
        let result = try await auth.signIn(withPresenting: presenter)
        if let token = result.user.idToken?.tokenString {
            return token
        }
        throw AuthError.emptySocialToken
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
    
    @MainActor
    func loginWithApple() async throws -> String {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        let authorization = try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.appleContinuation = continuation
            controller.performRequests()
        }
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityToken = credential.identityToken,
           let idToken = String(data: identityToken, encoding: .utf8) {
            return idToken
        }
        
        throw AuthError.emptySocialToken
    }
    
    func kakaoLoginHandler(_ result: KakaoSDKAuth.OAuthToken?, _ error: Error?) {
        if let result {
            kakaoContinuation?.resume(returning: result)
            kakaoContinuation = nil
            return
        }
        
        kakaoContinuation?.resume(throwing: error ?? AuthError.failedKakaoLogin)
        kakaoContinuation = nil
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
        appleContinuation?.resume(throwing: error)
        appleContinuation = nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        appleContinuation?.resume(returning: authorization)
        appleContinuation = nil
    }
    
}
