//
//  OnboardingGuideView.swift
//  Dayme
//
//  Created by 김남건 on 1/11/25.
//

import UIKit
import PinLayout
import Then

class OnboardingGuideView: UIView {
    private let messageLabel = UILabel().then {
        $0.textColor(.white).font(.pretendard(.bold, 14))
        $0.numberOfLines = 0
    }
    
    private let bubbleView = UIView().then {
        $0.backgroundColor = .hex("33373A")
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let tailView = UIImageView(image: UIImage.messageTail)
    private let tailOffset: CGFloat
    private let reversed: Bool
    
    init(message: String, tailOffset: CGFloat = 0, reversed: Bool = false) {
        self.tailOffset = tailOffset
        self.reversed = reversed
        
        super.init(frame: .zero)
        messageLabel.text = message
        
        [bubbleView, tailView].forEach(addSubview(_:))
        bubbleView.addSubview(messageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if reversed {
            tailView.transform = .init(rotationAngle: Double.pi)
            bubbleView.pin.top(17).left().right().bottom()
            tailView.pin.width(23).height(24).hCenter(tailOffset).top()
        } else {
            bubbleView.pin.top().left().right().bottom(17)
            tailView.pin.width(23).height(24).hCenter(tailOffset).bottom()
        }
        
        messageLabel.pin.vertically(12).horizontally(17)
    }
}
