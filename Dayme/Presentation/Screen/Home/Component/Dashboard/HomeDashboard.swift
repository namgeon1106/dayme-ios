//
//  HomeDashboard.swift
//  Dayme
//
//  Created by 정동천 on 12/5/24.
//

import UIKit

final class HomeDashboard: Vue {
    
    private(set) var nickname: String = "OOO"
    private(set) var goals: [Goal] = []
    
    // MARK: UI Properties
    
    private let titleLbl = UILabel().then {
        $0.textColor(.black)
            .numberOfLines(0)
            .font(.pretendard(.semiBold, 16))
    }
    
    private let emptyLbl = UILabel("앗, 아직 설정된 목표가 없어요 !").then {
        $0.textColor(.colorGrey30).font(.pretendard(.bold, 14))
    }
    
    private let goalContainer = UIView()
    
    private let manageGoalBtn = FilledSecondaryButton("주요목표 관리")
    
    
    // MARK: Helpers
    
    override func setup() {
        backgroundColor = .colorBackground
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous
        addShadow(.card)
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.padding(16, 20).define { flex in
            flex.addItem(titleLbl)
            
            flex.addItem().marginTop(16).height(1)
                .backgroundColor(.colorGrey20)
            
            flex.addItem(goalContainer).marginTop(20)
            
            flex.addItem().grow(1)
            
            flex.addItem().alignItems(.center).define { flex in
                flex.addItem(manageGoalBtn)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout(mode: .adjustHeight)
    }
    
    
    func update(nickname: String? = nil, goals: [Goal]? = nil) {
        let nickname = nickname ?? self.nickname
        let goals = goals ?? self.goals
        
        self.nickname = nickname
        self.goals = goals
        
        let comment = if let goal = goals.first {
            "\n\(goal.title)까지 \(String(format: "%.0f", goal.progress * 100))%달성했어요 !"
        } else {
            "어떤 목표를 이루고 싶으신가요 ?"
        }
        
        titleLbl.text = "\(nickname)님, \(comment)"
        titleLbl.lineHeight(multiple: 1.2)
        titleLbl.flex.markDirty()
        
        goalContainer.flex.isIncludedInLayout = false
        goalContainer.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        if goals.isEmpty {
            goalContainer.flex.alignItems(.center).justifyContent(.center).define { flex in
                flex.addItem(emptyLbl).marginBottom(20)
            }
        } else {
            goalContainer.flex.alignItems(.stretch).justifyContent(.start).define { flex in
                goals.forEach { goal in
                    let trackingView = GoalTrackingView(goal)
                    flex.addItem(trackingView).marginBottom(20)
                }
            }
        }
        
        goalContainer.flex.isIncludedInLayout = true
        setNeedsLayout()
    }
    
}
