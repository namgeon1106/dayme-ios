//
//  MainTC.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

final class MainTC: UITabBarController {
    
    weak var coordinator: Coordinator?
    
    init(_ viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = viewControllers
        self.selectedIndex = 2
        
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// MARK: - UITabBarControllerDelegate

extension MainTC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        Haptic.impact(.light)
    }
    
}
