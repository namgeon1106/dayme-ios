//
//  CustomAlertView.swift
//  Dayme
//
//  Created by 김남건 on 2/9/25.
//

import UIKit
import FlexLayout
import PinLayout
import Then

final class CustomConfirmAlert: Vue, Anchor {
    enum Action {
        case cancel
        case primary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let alertView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
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
    
    private let cancelButton = UIButton().then {
        $0.setTitleColor(.colorGrey30, for: [])
        $0.titleLabel?.font(.pretendard(.medium, 16))
    }
    
    private let verticalDivier = UIView().backgroundColor(.colorGrey20)
    
    private var continuation: CheckedContinuation<Action, Never>? = nil
    
    let primaryButton = UIButton().then {
        $0.setTitleColor(.colorMain1, for: [])
        $0.titleLabel?.font(.pretendard(.bold, 16))
    }
    
    private let isCancellable: Bool
    
    init(title: String? = nil, message: String, primaryTitle: String?, isCancellable: Bool) {
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.primaryButton.setTitle(primaryTitle, for: [])
        self.cancelButton.setTitle("취소", for: [])
        self.isCancellable = isCancellable
        super.init(frame: .zero)
    }
    
    init(message: NSAttributedString, primaryTitle: String?, isCancellable: Bool) {
        self.messageLabel.attributedText = message
        self.primaryButton.setTitle(primaryTitle, for: [])
        self.cancelButton.setTitle("취소", for: [])
        self.isCancellable = isCancellable
        super.init(frame: .zero)
    }
    
    override func setup() {
        self.backgroundColor = .black.withAlphaComponent(0.45)
    }
    
    override func setupAction() {
        self.primaryButton.addTarget(self, action: #selector(primaryButtonDidTap), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    override func setupFlex() {
        self.addSubview(alertView)
        alertView.addSubview(messageLabel)
        alertView.addSubview(horizontalDivider)
        alertView.addSubview(primaryButton)
        
        if titleLabel.text != nil {
            alertView.addSubview(titleLabel)
        }
        
        if isCancellable {
            alertView.addSubview(cancelButton)
            alertView.addSubview(verticalDivier)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.pin.all()
        
        let height: CGFloat = titleLabel.text == nil ? 172 : 182
        alertView.pin.height(height).horizontally(24).vCenter()
        
        if titleLabel.text != nil {
            titleLabel.pin.top(20).horizontally(24).height(22)
            messageLabel.pin.top(to: titleLabel.edge.bottom).marginTop(16).height(48).horizontally(24)
        } else {
            messageLabel.pin.top(32).height(48).horizontally(24)
        }
        
        let messageLabelBottomMargin: CGFloat = titleLabel.text == nil ? 32 : 16
        horizontalDivider.pin.top(to: messageLabel.edge.bottom).marginTop(messageLabelBottomMargin)
            .horizontally(24).height(1)
        
        if isCancellable {
            verticalDivier.pin.top(to: horizontalDivider.edge.bottom).bottom().hCenter().width(1)
            cancelButton.pin.top(to: horizontalDivider.edge.bottom).left().bottom().right(to: verticalDivier.edge.left)
            primaryButton.pin.top(to: horizontalDivider.edge.bottom).right().bottom().left(to: verticalDivier.edge.right)
        } else {
            primaryButton.pin.top(to: horizontalDivider.edge.bottom).horizontally().bottom()
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
    
    func show(on view: UIView) {
        view.addSubview(self)
    }
    
    @discardableResult
    @MainActor
    func show(on view: UIView) async -> Action {
        view.addSubview(self)
        return await withCheckedContinuation { [weak self] continuation in
            if let self {
                self.continuation = continuation
            }
        }
    }
}
