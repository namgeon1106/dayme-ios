//
//  OnboardingSubgoalView.swift
//  Dayme
//
//  Created by 김남건 on 1/13/25.
//

import UIKit
import PinLayout

class OnboardingSubgoalView: Vue {
    private let emptyLbl = UILabel().then {
        $0.text("세부 목표가 설정되지 않았어요.\n세부 목표를 작성하고 목표를 관리해보세요!")
            .textColor(.colorGrey50)
            .textAlignment(.center)
            .font(.pretendard(.regular, 14))
            .numberOfLines(2)
            .lineHeight(multiple: 1.2)
    }
    
    private let addNoValueBtn = FilledSecondaryButton("세부목표 작성하기")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(emptyLbl)
        addSubview(addNoValueBtn)
    }
    
    @MainActor required init?(coder: NSCoder) {
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
            .width(110)
            .height(28)
        
    }
}
