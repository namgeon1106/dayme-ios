//
//  LoginVC.swift
//  Dayme
//
//  Created by 정동천 on 10/31/24.
//

import UIKit
import FlexLayout
import PinLayout

#Preview { LoginVC() }

final class LoginVC: VC {
    
    private let authService = AuthService()
    
    // MARK: UI properties
    
    private let logo = UILabel("DAYME")
    private let subTitleLbl = UILabel(L10n.Login.subTitle)
    
    private let kakaoBtn = SocialLoginButton(.kakao)
    private let googleBtn = SocialLoginButton(.google)
    private let appleBtn = SocialLoginButton(.apple)
    
    // MARK: Helpers
    
    override func setup() {
        addKeyboardObeserver()
        view.backgroundColor(.colorBackground)
        
        logo.textColor(.colorMain1)
            .font(.montserrat(.black, 32))
            .textAlignment(.center)
        
        subTitleLbl.textColor(.colorDarkVoid)
            .font(.montserrat(.black, 24))
            .textAlignment(.center)
            .numberOfLines(0)
            .lineHeight(multiple: 1.2)
    }
    
    override func setupAction() {
        for socialButton in [googleBtn, kakaoBtn, appleBtn] {
            socialButton.onAction { [weak self] in
                await self?.loginWithSocial(socialButton.provider)
            }
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem()
                .alignItems(.center)
                .justifyContent(.center)
                .grow(1)
                .define { flex in
                    flex.addItem(logo)
                    flex.addItem(subTitleLbl).marginTop(20)
                    flex.addItem().height(80)
                }
            
            // 소셜 로그인 영역
            flex.addItem().padding(0, 16).marginVertical(26).define { flex in
                flex.addItem(googleBtn).height(56)
                flex.addItem(kakaoBtn).height(56).marginTop(8)
                flex.addItem(appleBtn).height(56).marginTop(8)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all(view.safeAreaInsets)
        flexView.flex.layout()
    }
    
    func showAlert(title: String, message: String) {
        Haptic.noti(.warning)
        
        Alert(title: title, message: message)
            .onAction(title: "확인")
            .show(on: self)
    }
    
}

// MARK: - Auth

private extension LoginVC {
    
    func loginWithSocial(_ provider: OAuthProvider) async {
        do {
            let idToken = try await authService.getSocialIdToken(provider, presenter: self)
            Loader.show(in: view)
            
            do {
                try await authService.loginWithSocial(provider, idToken: idToken)
                Loader.dismiss()
                coordinator?.trigger(with: .loginFinished)
                Haptic.noti(.success)
            } catch let error as ServerError where error.errorCode == .memberIdentityNotFound {
                Loader.dismiss()
                await signupWithSocial(provider, idToken: idToken)
            }
        } catch AuthError.canceled {
            Loader.dismiss()
            Logger.debug { AuthError.canceled.localizedDescription }
        } catch {
            Loader.dismiss()
            Logger.error { "로그인 에러: \(error)" }
            
            showAlert(title: "🚨 로그인 에러", message: error.localizedDescription)
        }
    }
    
    func signupWithSocial(_ provider: OAuthProvider, idToken: String) async {
        coordinator?.trigger(with: .signupNeeded)
    }
    
}
