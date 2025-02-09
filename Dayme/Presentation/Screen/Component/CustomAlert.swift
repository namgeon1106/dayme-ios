//
//  CustomAlertView.swift
//  Dayme
//
//  Created by 김남건 on 2/9/25.
//

import UIKit
import PinLayout
import Then

final class CustomAlert: Vue {
    enum Action {
        case cancel
        case primary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let alertView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let labelStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private let titleLabel = UILabel()
        .font(.pretendard(.bold, 18))
        .textAlignment(.center)
    
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
    
    let cancelButton = UIButton().then {
        $0.tintColor = .colorGrey30
        $0.titleLabel?.font(.pretendard(.medium, 16))
    }
    
    private let verticalDivier = UIView().backgroundColor(.colorGrey20)
    
    var continuation: CheckedContinuation<Action, Never>? = nil
    
    let primaryButton = UIButton().then {
        $0.tintColor = .colorMain1
        $0.titleLabel?.font(.pretendard(.bold, 16))
    }
    
    init(title: String? = nil, message: String, primaryTitle: String?, cancelTitle: String?) {
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.primaryButton.setTitle(primaryTitle, for: [])
        self.cancelButton.setTitle(cancelTitle, for: [])
        super.init(frame: .zero)
    }
    
    init(message: NSAttributedString, primaryTitle: String?, cancelTitle: String?) {
        self.messageLabel.attributedText = message
        self.primaryButton.setTitle(primaryTitle, for: [])
        self.cancelButton.setTitle(cancelTitle, for: [])
        super.init(frame: .zero)
    }
    
    override func setup() {
        self.backgroundColor = .black.withAlphaComponent(0.45)
        self.addSubview(alertView)
        [titleLabel, messageLabel].forEach(labelStack.addArrangedSubview(_:))
        [cancelButton, verticalDivier, primaryButton].forEach(buttonsStack.addArrangedSubview(_:))
        [labelStack, horizontalDivider, buttonsStack].forEach(alertView.addSubview(_:))
        
        titleLabel.isHidden = titleLabel.text == nil
        buttonsStack.isHidden = primaryButton.title(for: []) == nil
        
        if cancelButton.title(for: []) == nil {
            cancelButton.isHidden = true
            verticalDivier.isHidden = true
        }
    }
    
    override func setupAction() {
        self.primaryButton.addTarget(self, action: #selector(primaryButtonDidTap), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelStack.pin.top(32).horizontally(24)
        
        alertView.pin.horizontally(24).vCenter()
        
        if primaryButton.title(for: []) == nil {
            messageLabel.pin.bottom(32)
        } else {
            horizontalDivider.pin.top(to: messageLabel.edge.bottom).marginTop(32).horizontally(24).height(1)
            buttonsStack.pin.top(to: horizontalDivider.edge.bottom).horizontally().bottom().height(60)
            verticalDivier.pin.width(1).height(42)
        }
    }
    
    @objc
    private func primaryButtonDidTap() {
        self.removeFromSuperview()
        continuation?.resume(returning: .primary)
        continuation = nil
    }
    
    @objc
    private func cancelButtonDidTap() {
        self.removeFromSuperview()
        continuation?.resume(returning: .cancel)
        continuation = nil
    }
    
    func show(on vc: UIViewController) {
        vc.view.addSubview(self)
        self.pin.all()
    }
    
    @MainActor
    func show(on vc: UIViewController) async -> Action {
        return await withCheckedContinuation { [weak self] continuation in
            self?.continuation = continuation
        }
    }
}
