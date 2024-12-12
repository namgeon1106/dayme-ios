//
//  GoalTrackingView.swift
//  Dayme
//
//  Created by 정동천 on 12/5/24.
//

import UIKit

final class GoalTrackingView: Vue {
    
    let goal: Goal
    
    private lazy var emojiLbl = UILabel(goal.emoji).then {
        $0.font(.pretendard(.semiBold, 24))
    }
    
    private lazy var titleLbl = UILabel(goal.title).then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 14))
    }
    
    private lazy var progressLbl = UILabel().then {
        $0.text(String(format: "%.0f", goal.progress * 100))
            .textColor(.colorGrey50)
            .font(.pretendard(.bold, 12))
    }
    
    private lazy var progressBar = ProgressBar().then {
        $0.progress = goal.progress
        $0.tintColor = .hex(goal.hex)
    }
    
    init(_ goal: Goal) {
        self.goal = goal
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.direction(.row).alignItems(.center).height(24).define { flex in
            flex.addItem(emojiLbl).margin(1, 0, 0, 8)
            
            flex.addItem().grow(1).define { flex in
                flex.addItem().direction(.row).grow(1).define { flex in
                    flex.addItem(titleLbl)
                    
                    flex.addItem().grow(1)
                    
                    flex.addItem(progressLbl)
                }
                
                flex.addItem(progressBar).marginTop(4).height(6)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
    }
    
}
