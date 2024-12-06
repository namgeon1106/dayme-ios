//
//  GoalCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/24/24.
//

import UIKit

final class GoalCoordinator: Coordinator {
    
    override func start(animated: Bool) {
        let goalVC = GoalVC()
        goalVC.coordinator = self
        nav.viewControllers = [goalVC]
    }
    
    override func trigger(with event: FlowEvent) {
        switch event {
        case .goalAddNeeded:
            pushGoalAddScreen()
            
        case .goalAddCanceled:
            popViewController(animated: true)
            
        default: break
        }
    }
    
}

// MARK: - Navigate

private extension GoalCoordinator {
    
    func pushGoalAddScreen() {
        let goalAddVC = GoalAddVC()
        goalAddVC.coordinator = self
        goalAddVC.hidesBottomBarWhenPushed = true
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.pushViewController(goalAddVC, animated: true)
    }
    
}
