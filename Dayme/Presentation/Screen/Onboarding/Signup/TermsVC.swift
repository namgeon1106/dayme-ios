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

#Preview { TermsVC() }

final class TermsVC: VC {
    
    // MARK: UI properties
    
    private let backBtn = UIButton().then {
        $0.image(.icBackward, for: .normal)
    }
    
    private let logo = UILabel("DAYME").then {
        $0.textColor(.colorMain1)
            .font(.montserrat(.black, 32))
    }
    
    private let subTitleLbl = UILabel(L10n.Terms.subTitle).then {
        $0.textColor(.colorDarkVoid)
            .font(.montserrat(.black, 24))
            .textAlignment(.left)
            .numberOfLines(0)
            .lineHeight(multiple: 1.2)
    }
    
    private let agreeAllBtn = UIButton().then {
        var attrString = AttributedString(L10n.Terms.agreeAll)
        attrString.font = .pretendard(.bold, 18)
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .colorDarkVoid
        config.attributedTitle = attrString
        config.image = .icCheckOff
        config.imagePadding = 6
        config.contentInsets = .zero
        $0.configuration = config
    }
    
    private let serviceAgreeBtn = UIButton().then {
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
    
    private let privacyAgreeBtn = UIButton().then {
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
                flex.addItem(serviceAgreeBtn)
                flex.addItem().grow(1)
                flex.addItem(serviceShowBtn).width(44)
            }
            
            flex.addItem().direction(.row).height(36).padding(0, 24, 0, 5).define { flex in
                flex.addItem(privacyAgreeBtn)
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
    
}
