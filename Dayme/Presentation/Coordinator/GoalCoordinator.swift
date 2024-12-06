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
    
}
