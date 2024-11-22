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
        scrollView.keyboardDismissMode = .onDrag
        
        logo.textColor(.accent)
            .font(.systemFont(ofSize: 32, weight: .black))
            .textAlignment(.center)
        separatorLbl.textColor(.colorContentSecondary)
            .font(.systemFont(ofSize: 14, weight: .regular))
            .textAlignment(.center)
        
        emailTF.keyboardType = .emailAddress
        emailTF.returnKeyType = .next
        emailTF.delegate = self
        pwTF.keyboardType = .asciiCapable
        pwTF.returnKeyType = .done
        pwTF.isSecureTextEntry = true
    }
    
    override func setupAction() {
        loginBtn.onAction { [weak self] in
            self?.view.endEditing(true)
            await self?.login()
        }
        
        for socialButton in [googleBtn, kakaoBtn, appleBtn] {
            socialButton.onAction { [weak self] in
                self?.view.endEditing(true)
                await self?.loginWithSocial(socialButton.provider)
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
    
    func showAlert(title: String, message: String) {
        Alert(title: title, message: message)
            .onAction(title: "확인")
            .show(on: self)
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9]+([._%+-]*[A-Za-z0-9])?@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
}

// MARK: - Auth

private extension LoginVC {
    
    func login() async {
        let email = emailTF.text.orEmpty
        let password = pwTF.text.orEmpty
        
        if email.isEmpty || password.isEmpty {
            showAlert(title: "⚠️ 입력 오류", message: "이메일과 비밀번호를 모두 입력해주세요.")
            return
        } else if !validateEmail(email) {
            showAlert(title: "⚠️ 입력 오류", message: "유효한 이메일 주소를 입력해주세요.")
            return
        }
        
        Loader.show(in: view)
        
        do {
            try await authService.login(email: email, password: password)
            Loader.dismiss()
        } catch {
            Loader.dismiss()
            Logger.error { "로그인 에러: \(error)" }
            
            showAlert(title: "🚨 로그인 에러", message: error.localizedDescription)
        }
    }
    
    func loginWithSocial(_ provider: OAuthProvider) async {
        do {
            let idToken = try await authService.getSocialIdToken(provider, presenter: self)
            
            do {
                try await authService.loginWithSocial(provider, idToken: idToken)
            } catch let error as ServerError where error.errorCode == .memberIdentityNotFound {
                await signupWithSocial(provider, idToken: idToken)
            }
        } catch AuthError.canceled {
            Logger.debug { AuthError.canceled.localizedDescription }
        } catch {
            Logger.error { "로그인 에러: \(error)" }
            
            showAlert(title: "🚨 로그인 에러", message: error.localizedDescription)
        }
    }
    
    func signupWithSocial(_ provider: OAuthProvider, idToken: String) async {
        guard let nickname = await NicknamePopup.presentForNickname(on: self) else {
            return
        }
        
        Loader.show(in: view)
        
        do {
            try await authService.signupWithSocial(provider, nickname: nickname, idToken: idToken)
            Loader.dismiss()
        } catch {
            Loader.dismiss()
            showAlert(title: "🚨 회원가입 에러", message: error.localizedDescription)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            pwTF.becomeFirstResponder()
        } else if textField == pwTF {
            Task { await login() }
        }
        return true
    }
    
}

// MARK: - 임시 Alert

final class NicknamePopup: UIAlertController {
    
    var continuation: CheckedContinuation<String?, Never>?
    var textField: UITextField!
    
    static func presentForNickname(on viewController: UIViewController, animated: Bool = true) async -> String? {
        return await withCheckedContinuation { continuation in
            let alert = NicknamePopup(
                title: "회원가입",
                message: "사용할 닉네임을 입력하세요.",
                preferredStyle: .alert
            )
            alert.setup()
            alert.continuation = continuation
            
            viewController.present(alert, animated: animated)
        }
    }
    
    private func setup() {
        addTextField { [weak self] textField in
            textField.placeholder = "닉네임을 입력하세요"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.clearButtonMode = .whileEditing
            self?.textField = textField
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.continuation?.resume(returning: self?.textField.text)
        }
        confirmAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            self?.continuation?.resume(returning: nil)
        }
        
        textField.addAction(UIAction { [weak self] _ in
            confirmAction.isEnabled = !(self?.textField.text ?? "").isEmpty
        }, for: .editingChanged)
        
        addAction(confirmAction)
        addAction(cancelAction)
    }
    
}
