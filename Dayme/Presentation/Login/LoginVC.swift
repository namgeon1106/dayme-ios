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

#Preview { LoginVC() }

final class LoginVC: VC {
    
    // MARK: UI properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logo = UILabel("DAYME")
    private let emailTF = FilledTextField("이메일을 입력해주세요")
    private let pwTF = FilledTextField("비밀번호를 입력해주세요")
    private let loginBtn = FilledButton("로그인")
    
    private let separatorLbl = UILabel("혹은")
    private let googleBtn = SocialLoginButton(.icSocialGoogle, "구글 계정으로 로그인")
    private let kakaoBtn = SocialLoginButton(.icSocialKakao, "카카오톡으로 로그인")
    private let appleBtn = SocialLoginButton(.icSocialApple, "애플 계정으로 로그인")
    
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
        googleBtn.onAction { [weak self] in await self?.loginGoogle() }
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
    
    override func keyboardWillHide(_ height: CGFloat) {
        scrollView.contentInset.bottom = height
    }
    
}

// MARK: - Action

extension LoginVC {
    
    private func loginGoogle() async {
        do {
            let auth = GIDSignIn.sharedInstance
            let result = try await auth.signIn(withPresenting: self)
            let token = result.user.idToken?.tokenString
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}
