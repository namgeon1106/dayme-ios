//
//  TermsVC.swift
//  Dayme
//
//  Created by 정동천 on 11/26/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then

#if DEBUG
#Preview { TermsVC() }
#endif

final class TermsVM: ObservableObject {
    @Published var agreeAll: Bool = false
    @Published var agreeService: Bool = false
    @Published var agreePrivacy: Bool = false
}

final class TermsVC: VC {
    
    private let vm = TermsVM()
    
    // MARK: UI properties
    
    private let backBtn = UIButton().then {
        $0.image(.icBackward, for: .normal)
    }
    
    private let logo = UILabel("DAYME").then {
        $0.textColor(.colorMain1)
            .font(.montserrat(.black, 32))
    }
    
    private let subTitleLbl = UILabel(L10n.Terms.subTitle).then {
        $0.textColor(.colorDark100)
            .textAlignment(.left)
            .numberOfLines(0)
            .typo(.title24B)
    }
    
    private let agreeAllBtn = UIButton().then {
        var attrString = AttributedString(L10n.Terms.agreeAll)
        attrString.font = .pretendard(.bold, 18)
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .colorDark100
        config.attributedTitle = attrString
        config.image = .icCheckOff
        config.imagePadding = 6
        config.contentInsets = .zero
        $0.configuration = config
    }
    
    private let agreeServiceBtn = UIButton().then {
        var attrString = AttributedString(L10n.Terms.termsOfService)
        attrString.font = .pretendard(.medium, 16)
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .colorDark70
        config.attributedTitle = attrString
        config.image = .icCheckOff
        config.imagePadding = 10
        config.contentInsets = .zero
        $0.configuration = config
    }
    
    private let agreePrivacyBtn = UIButton().then {
        var attrString = AttributedString(L10n.Terms.privacyPolicy)
        attrString.font = .pretendard(.medium, 16)
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .colorDark70
        config.attributedTitle = attrString
        config.image = .icCheckOff
        config.imagePadding = 10
        config.contentInsets = .zero
        $0.configuration = config
    }
    
    private let serviceShowBtn = UIButton().then {
        $0.image(.icForeward, for: .normal)
    }
    
    private let privacyShowBtn = UIButton().then {
        $0.image(.icForeward, for: .normal)
    }
    
    private let startBtn = FilledButton(L10n.Terms.start)
    
    // MARK: Helpers
    
    override func setup() {
        view.backgroundColor(.colorBackground)
    }
    
    override func setupAction() {
        backBtn.onAction { [weak self] in
            self?.coordinator?.trigger(with: .signupCanceled)
        }
        
        startBtn.onAction { [weak self] in
            self?.coordinator?.trigger(with: .nicknameNeeded)
        }
        
        serviceShowBtn.onAction { [weak self] in
            self?.coordinator?.trigger(with: .termsNeeded(.termsOfService))
        }
        
        privacyShowBtn.onAction { [weak self] in
            self?.coordinator?.trigger(with: .termsNeeded(.privacyPolicy))
        }
        
        agreeAllBtn.onAction { [weak self] in
            guard let self else { return }
            vm.agreeAll.toggle()
            vm.agreePrivacy = vm.agreeAll
            vm.agreeService = vm.agreeAll
        }
        
        agreePrivacyBtn.onAction { [weak self] in
            guard let self else { return }
            vm.agreePrivacy.toggle()
            vm.agreeAll = vm.agreePrivacy && vm.agreeService
        }
        
        agreeServiceBtn.onAction { [weak self] in
            guard let self else { return }
            vm.agreeService.toggle()
            vm.agreeAll = vm.agreePrivacy && vm.agreeService
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        
        flexView.flex.padding(0, 8).define { flex in
            flex.addItem().marginTop(19).alignItems(.start).define { flex in
                flex.addItem(backBtn).width(44).height(44)
                flex.addItem(logo).marginTop(27).marginLeft(16)
                flex.addItem(subTitleLbl).marginTop(32).marginLeft(16)
            }
            
            flex.addItem().grow(1)
            
            flex.addItem().alignItems(.start).marginBottom(15).padding(0, 24).define { flex in
                flex.addItem(agreeAllBtn).height(56)
                flex.addItem().height(1).width(100%).backgroundColor(.colorGrey20)
            }
            
            flex.addItem().direction(.row).height(36).padding(0, 24, 0, 5).define { flex in
                flex.addItem(agreeServiceBtn)
                flex.addItem().grow(1)
                flex.addItem(serviceShowBtn).width(44)
            }
            
            flex.addItem().direction(.row).height(36).padding(0, 24, 0, 5).define { flex in
                flex.addItem(agreePrivacyBtn)
                flex.addItem().grow(1)
                flex.addItem(privacyShowBtn).width(44)
            }
            
            flex.addItem().marginTop(18).marginBottom(24).padding(0, 16).define { flex in
                flex.addItem(startBtn).height(56)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all(view.safeAreaInsets)
        flexView.flex.layout()
    }
    
    override func bind() {
        vm.$agreeAll.receive(on: RunLoop.main)
            .sink { [weak self] (agree: Bool) in
                let image: UIImage = agree ? .icCheckOn : .icCheckOff
                self?.agreeAllBtn.setImage(image, for: .normal)
                self?.startBtn.isEnabled = agree
            }.store(in: &cancellables)
        
        vm.$agreeService.receive(on: RunLoop.main)
            .sink { [weak self] (agree: Bool) in
                let image: UIImage = agree ? .icCheckOn : .icCheckOff
                self?.agreeServiceBtn.setImage(image, for: .normal)
            }.store(in: &cancellables)
        
        vm.$agreePrivacy.receive(on: RunLoop.main)
            .sink { [weak self] (agree: Bool) in
                let image: UIImage = agree ? .icCheckOn : .icCheckOff
                self?.agreePrivacyBtn.setImage(image, for: .normal)
            }.store(in: &cancellables)
    }
    
}
