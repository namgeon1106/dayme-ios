//
//  MainTC.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

final class MainTC: UITabBarController {
    
    weak var coordinator: Coordinator?
    
    private let vm = MainVM()
    
    
    init(_ viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = viewControllers
        
        tabBar.tintColor = .colorMain1
        tabBar.unselectedItemTintColor = .colorGrey30
        tabBar.isTranslucent = false
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
