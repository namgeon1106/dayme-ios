//
//  HomeCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/24/24.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    override func start(animated: Bool) {
        nav.viewControllers = [HomeVC()]
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = .init(style: .regular)
        appearance.shadowColor = nil
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.prefersLargeTitles = false
    }
    
}
