//
//  SettingCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/24/24.
//

import UIKit

final class SettingCoordinator: Coordinator {
    
    override func start(animated: Bool) {
        let settingVC = SettingVC()
        settingVC.coordinator = self
        nav.viewControllers = [settingVC]
    }
    
    override func trigger(with event: FlowEvent) {
        switch event {
        case .logout:
            parent?.trigger(with: event)
            
        default:
            break
        }
    }
    
}
