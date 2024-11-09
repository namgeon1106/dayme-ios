//
//  LoginVC.swift
//  Dayme
//
//  Created by 정동천 on 10/31/24.
//

import UIKit
import FlexLayout
import PinLayout
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import AuthenticationServices

#Preview { LoginVC() }

final class LoginVC: VC {
    
    private let authService = AuthService()
    
    // MARK: UI properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logo = UILabel("DAYME")
    private let emailTF = FilledTextField(L10n.Login.emailTF)
    private let pwTF = FilledTextField(L10n.Login.pwTF)
    private let loginBtn = FilledButton(L10n.Login.loginButton)
    
    private let separatorLbl = UILabel(L10n.Login.separataor)
    private let googleBtn = SocialLoginButton(.google)
    private let kakaoBtn = SocialLoginButton(.kakao)
    private let appleBtn = SocialLoginButton(.apple)
    
    // MARK: Helpers
    
    override func setup() {
        addKeyboardObeserver()
        view.backgroundColor(.colorBackground)
        scrollView.keyboardDismissMode = .interactive
        pwTF.isSecureTextEntry = true
        logo.textColor(.accent)
            .font(.systemFont(ofSize: 32, weight: .black))
            .textAlignment(.center)
        separatorLbl.textColor(.colorContentSecondary)
            .font(.systemFont(ofSize: 14, weight: .regular))
            .textAlignment(.center)
    }
    
    override func setupAction() {
        for socialButton in [googleBtn, kakaoBtn, appleBtn] {
            socialButton.onAction { [weak self] in
                try? await self?.authService.loginWithSocial(socialButton.provider, presenter: self)
            }
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.direction(.column).padding(64, 16).define { flex in
            flex.addItem(logo)
            
            // 이메일 로그인 영역
            flex.addItem().direction(.column).marginTop(32).define { flex in
                flex.addItem(emailTF).height(56)
                flex.addItem(pwTF).height(56).marginTop(16)
                flex.addItem(loginBtn).height(56).marginTop(16)
            }
            
            // 분리 영역
            flex.addItem().height(20).marginTop(32).alignItems(.center).justifyContent(.center).define { flex in
                // 분리 선
                flex.addItem().width(100%).height(1).backgroundColor(.colorSeparator).position(.absolute)
                
                // '혹은'
                flex.addItem(separatorLbl).backgroundColor(.colorBackground).paddingHorizontal(10)
            }
            
            // 소셜 로그인 영역
            flex.addItem().direction(.column).marginTop(32).define { flex in
                flex.addItem(googleBtn).height(56)
                flex.addItem(kakaoBtn).height(56).marginTop(16)
                flex.addItem(appleBtn).height(56).marginTop(16)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        scrollView.pin.all()
        contentView.pin.top(view.pin.safeArea.top).bottom().horizontally()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.bounds.size
    }
    
    override func keyboardWillShow(_ height: CGFloat) {
        scrollView.contentInset.bottom = height + view.safeAreaInsets.bottom
    }
    
    override func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
    }
    
}
