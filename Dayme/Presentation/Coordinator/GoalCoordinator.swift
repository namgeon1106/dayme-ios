//
//  GoalCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/24/24.
//

import UIKit

final class GoalCoordinator: Coordinator {
    
    override func start(animated: Bool) {
        nav.viewControllers = [UIViewController()]
    }
    
}
