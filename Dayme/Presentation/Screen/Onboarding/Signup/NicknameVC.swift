//
//  NicknameVC.swift
//  Dayme
//
//  Created by 정동천 on 11/27/24.
//

import UIKit
import Combine
import FlexLayout
import PinLayout
import Then

#if DEBUG
#Preview { NicknameVC() }
#endif

final class NicknameVM: ObservableObject {
    @Published var nickname: String = ""
}

final class NicknameVC: VC {
    
    private let authInfo: OAuthSignupInfo
    private let vm = NicknameVM()
    private let authService = AuthService()
    private let userService: UserService = .shared
    
    private let maxLength: Int = 10
    
    // MARK: UI properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backBtn = UIButton().then {
        $0.image(.icBackward, for: .normal)
    }
    
    private let logo = UILabel("DAYME").then {
        $0.textColor(.colorMain1)
            .font(.montserrat(.black, 32))
    }
    
    private let subTitleLbl = UILabel(L10n.Nickname.subTitle).then {
        $0.textColor(.colorDark100)
            .textAlignment(.left)
            .numberOfLines(0)
            .typo(.title24B)
    }
    
    private let captionLbl = UILabel(L10n.Nickname.caption).then {
        $0.textColor(.hex("#808080"))
            .font(Typo.body16M.font)
    }
    
    private let nicknameTF = UITextField(L10n.Nickname.placeholder).then {
        $0.font(Typo.body20M.font)
        $0.textColor(.colorDark70)
        $0.returnKeyType = .done
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.clearButtonMode = .always
    }
    
    private let currentLengthLbl = UILabel("0 / ").then {
        $0.textColor(.colorGrey30)
            .font(Typo.body16M.font)
    }
    
    private let maximumLengthLbl = UILabel("10").then {
        $0.textColor(.colorGrey30)
            .font(Typo.body16B.font)
    }
    
    private let doneBtn = FilledButton(L10n.Nickname.done)
    
    // MARK: Lifecycle
    
    init(authInfo: OAuthSignupInfo) {
        self.authInfo = authInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nicknameTF.becomeFirstResponder()
    }
    
    // MARK: Helpers
    
    override func setup() {
        view.backgroundColor(.colorBackground)
        doneBtn.isEnabled = false
        nicknameTF.delegate = self
        addKeyboardObeserver()
    }
    
    override func setupAction() {
        backBtn.onAction { [weak self] in
            self?.coordinator?.trigger(with: .nicknameCanceled)
        }
        
        nicknameTF.onAction { [weak self] in
            guard let self else { return }
            vm.nickname = nicknameTF.text.orEmpty
        }
        
        doneBtn.onAction { [weak self] in
            await self?.signupWithSocial()
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.define { flex in
            flex.addItem().marginTop(19).alignItems(.start).define { flex in
                flex.addItem(backBtn).width(44).height(44).marginLeft(8)
            }
            
            flex.addItem().padding(0, 24).define { flex in
                flex.addItem(logo).marginTop(27)
                
                flex.addItem(subTitleLbl).marginTop(32)
                
                flex.addItem(captionLbl).marginTop(32)
                
                flex.addItem(nicknameTF).marginTop(6).height(40)
                
                flex.addItem().height(1).backgroundColor(.colorGrey20)
                
                flex.addItem().direction(.row).marginTop(6).define { flex in
                    flex.addItem(currentLengthLbl)
                    flex.addItem(maximumLengthLbl)
                }
                
                flex.addItem().marginTop(18).marginTop(32).define { flex in
                    flex.addItem(doneBtn).height(56)
                }
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.bounds.size
    }
    
    override func bind() {
        vm.$nickname.receive(on: RunLoop.main)
            .sink { [weak self] nickname in
                guard let self else { return }
                doneBtn.isEnabled = !nickname.isEmpty
                currentLengthLbl.text = "\(nickname.count) / "
                currentLengthLbl.flex.markDirty()
                contentView.flex.layout()
            }.store(in: &cancellables)
    }
    
    override func keyboardWillShow(_ height: CGFloat) {
        scrollView.contentInset.bottom = height
    }
    
    override func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
    }
    
}

// MARK: - Auth

private extension NicknameVC {
    
    func signupWithSocial() async {
        do {
            Loader.show(in: view)
            let nickname = nicknameTF.text.orEmpty
            let newInfo = authInfo.copyWith(nickname: nickname)
            // 회원가입 시도
            try await authService.signupWithSocial(newInfo)
            
            do {
                // 로그인 시도
                try await authService.loginWithSocial(
                    newInfo.provider,
                    idToken: newInfo.token
                )
                _ = try? await userService.getUser()
                
                Loader.dismiss()
                
                coordinator?.trigger(with: .loginFinished)
            } catch {
                Loader.dismiss()
                Logger.error { "로그인 에러: \(error)" }
                
                coordinator?.trigger(with: .signupFinished)
            }
        } catch {
            Loader.dismiss()
            Logger.error { "회원가입 에러: \(error)" }
            
            showAlert(title: "🚨 회원가입 에러", message: error.localizedDescription)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension NicknameVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {        
        let currentText = textField.text.orEmpty
        
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        
        let updatedText = currentText
            .replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= maxLength
    }
    
}
