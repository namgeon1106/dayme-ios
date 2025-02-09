//
//  CustomAlertView.swift
//  Dayme
//
//  Created by 김남건 on 2/9/25.
//

import UIKit
import PinLayout
import Then

final class CustomAlertView: Vue {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class CustomAction {
        let title: String
        let handler: () -> Void
        
        init(title: String, handler: @escaping () -> Void) {
            self.title = title
            self.handler = handler
        }
    }
    
    private let messageLabel = UILabel()
        .font(.pretendard(.medium, 16))
        .numberOfLines(0)
        .textAlignment(.center)
    
    private let horizontalDivider = UIView().backgroundColor(.colorGrey20)
    
    private let buttonsStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    private let cancelButton = UIButton().then {
        $0.tintColor = .colorGrey30
        $0.titleLabel?.font(.pretendard(.medium, 16))
    }
    
    private let verticalDivier = UIView().backgroundColor(.colorGrey20)
    
    private let primaryButton = UIButton().then {
        $0.tintColor = .colorMain1
        $0.titleLabel?.font(.pretendard(.bold, 16))
    }
    
    private let primaryAction: CustomAction
    private let cancelAction: CustomAction?
    
    init(message: String, primaryAction: CustomAction, cancelAction: CustomAction? = nil) {
        self.messageLabel.text = message
        self.primaryAction = primaryAction
        self.cancelAction = cancelAction
        super.init(frame: .zero)
    }
    
    init(message: NSAttributedString, primaryAction: CustomAction, cancelAction: CustomAction? = nil) {
        self.messageLabel.attributedText = message
        self.primaryAction = primaryAction
        self.cancelAction = cancelAction
        super.init(frame: .zero)
    }
    
    override func setup() {
        [cancelButton, verticalDivier, primaryButton].forEach(buttonsStack.addArrangedSubview(_:))
        [messageLabel, horizontalDivider, buttonsStack].forEach(addSubview(_:))
        if cancelAction == nil {
            cancelButton.isHidden = true
            verticalDivier.isHidden = true
        }
    }
    
    override func setupAction() {
        if let cancelAction {
            cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        }
        
        primaryButton.addTarget(self, action: #selector(primaryButtonDidTap), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        messageLabel.pin.top(32).horizontally(24)
        horizontalDivider.pin.top(to: messageLabel.edge.bottom).marginTop(32).horizontally(24).height(1)
        buttonsStack.pin.top(to: horizontalDivider.edge.bottom).horizontally().bottom().height(60)
        verticalDivier.pin.width(1).height(42)
    }
    
    @objc
    private func cancelButtonDidTap() {
        cancelAction?.handler()
    }
    
    @objc
    private func primaryButtonDidTap() {
        primaryAction.handler()
    }
}
