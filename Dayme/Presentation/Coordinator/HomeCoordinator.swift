//
//  HomeCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/24/24.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    override func start(animated: Bool) {
        let homeVC = HomeVC()
        homeVC.coordinator = self
        nav.viewControllers = [homeVC]
        
        setupNavigationBar()
    }
    
    override func trigger(with event: FlowEvent) {
        switch event {
        case .goalAddNeeded:
            pushGoalAddScreen()
        case .onboarding1Finished:
            pushGoalAddScreen()
        case .onboarding2Finished:
            popViewController(animated: false)
        case .goalAddCanceled:
            popViewController(animated: true)
        default:
            break
        }
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

// MARK: - navigation
private extension HomeCoordinator {
    func pushGoalAddScreen() {
        let goalAddVC = GoalAddVC()
        goalAddVC.coordinator = self
        goalAddVC.hidesBottomBarWhenPushed = true
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.pushViewController(goalAddVC, animated: false)
    }
}
