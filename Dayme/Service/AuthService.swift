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

enum AuthError: LocalizedError {
    case emptySocialToken
    case failedKakaoLogin
    
    var errorDescription: String? {
        switch self {
        case .emptySocialToken:
            "소셜 로그인 토큰을 가져오지 못했습니다."
        case .failedKakaoLogin:
            "알 수 없는 이유로 카카오 로그인에 실패하였습니다."
        }
    }
}

class AuthService: NSObject {
    
    private weak var presenter: UIViewController!
    
    private var kakaoContinuation: CheckedContinuation<KakaoSDKAuth.OAuthToken, Error>?
    private var appleContinuation: CheckedContinuation<ASAuthorization, Error>?
    
    @MainActor
    func loginWithSocial(_ provider: OAuthProvider, presenter: UIViewController!) async throws {
        self.presenter = presenter
        
        let token = switch provider {
        case .google: try await loginWithGoogle()
        case .kakao: try await loginWithKakao()
        case .apple: try await loginWithApple()
        }
        
        // 1. 키체인 저장
        // 2. 서버 로그인 시도
    }
    
}

private extension AuthService {
    
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
        if let kakaoKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String {
            KakaoSDK.initSDK(appKey: kakaoKey)
        }
        
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
