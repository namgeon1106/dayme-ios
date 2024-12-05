//
//  HomeDashboard.swift
//  Dayme
//
//  Created by 정동천 on 12/5/24.
//

import UIKit

final class HomeDashboard: Vue {
    
    private var items: [GoalTrackingItem] = []
    
    // MARK: UI Properties
    
    private let titleLbl = UILabel().then {
        $0.textColor(.black)
            .numberOfLines(0)
            .typo(.body16M)
    }
    
    private let goalContainer = UIView()
    
    private let manageGoalBtn = FilledSecondaryButton("주요목표 관리")
    
    
    func updateItems(_ items: [GoalTrackingItem]) {
        self.items = items
        
        goalContainer.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        goalContainer.flex.define { flex in
            items.forEach { item in
                let trackingView = GoalTrackingView(item)
                flex.addItem(trackingView).marginBottom(20)
            }
        }
        
        setNeedsLayout()
    }
    
    // MARK: Helpers
    
    override func setup() {
        backgroundColor = .colorBackground
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous
        addShadow(.default)
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
    }
    
    override func bind() {
        titleLbl.text = "우채윤님,\n토익 900점 달성까지 49% 달성했어요!"
        titleLbl.lineHeight(multiple: 1.2)
    }
    
}
