//
//  OnboardingSubgoalView.swift
//  Dayme
//
//  Created by 김남건 on 1/13/25.
//

import UIKit
import PinLayout

class OnboardingFocusedView: Vue {
    private let emptyLbl: UILabel
    
    private let addNoValueBtn: FilledSecondaryButton
    private let buttonWidth: CGFloat
    
    init(message: String, buttonTitle: String, buttonWidth: CGFloat) {
        emptyLbl = UILabel().then {
            $0.text(message)
                .textColor(.colorGrey50)
                .textAlignment(.center)
                .font(.pretendard(.regular, 14))
                .numberOfLines(2)
                .lineHeight(multiple: 1.2)
        }
        addNoValueBtn = FilledSecondaryButton(buttonTitle)
        self.buttonWidth = buttonWidth
        
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(emptyLbl)
        addSubview(addNoValueBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emptyLbl.pin
            .horizontally()
            .height(42)
            .top(20)
        
        addNoValueBtn.pin
            .top(to: emptyLbl.edge.bottom)
            .marginTop(8)
            .hCenter()
            .width(buttonWidth)
            .height(28)
        
    }
}
