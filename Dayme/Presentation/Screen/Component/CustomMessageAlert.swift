//
//  CustomMessageAlert.swift
//  Dayme
//
//  Created by 김남건 on 2/12/25.
//

import UIKit
import PinLayout

class CustomMessageAlert: Vue {
    private let alertView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    
    private let messageLabel = UILabel()
        .font(.pretendard(.medium, 16))
        .numberOfLines(0)
        .textAlignment(.center)
    
    init(message: String) {
        self.messageLabel.text = message
        super.init(frame: .zero)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        self.backgroundColor = .black.withAlphaComponent(0.45)
    }
    
    override func setupFlex() {
        self.addSubview(alertView)
        alertView.addSubview(messageLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.pin.all()
        alertView.pin.minHeight(88)
            .vCenter()
            .horizontally(24)
        messageLabel.pin.minHeight(24).maxHeight(48)
            .horizontally(24)
            .vertically(32)
    }
    
    func show(on vc: UIViewController) {
        vc.view.addSubview(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.removeFromSuperview()
        }
    }
}
