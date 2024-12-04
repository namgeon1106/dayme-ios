//
//  MainCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    override func start(animated: Bool) {
        let navs = MainTab.allCases.map(nav)
        let mainTC = MainTC(navs)
        mainTC.coordinator = self
        
        if animated {
            addFadeTransaction(in: nav.view.layer)
        }
        
        nav.viewControllers = [mainTC]
    }
    
    override func trigger(with event: FlowEvent) {
        switch event {
        case .logout, .userDeleted:
            parent?.trigger(with: event)
            
        default:
            break
        }
    }
    
}

private extension MainCoordinator {
    
    func startFlow(tab: MainTab, nav: UINavigationController) {
        let child = switch tab {
        case .home: HomeCoordinator(nav: nav)
        case .goal: GoalCoordinator(nav: nav)
        case .setting: SettingCoordinator(nav: nav)
        }
        startFlow(child, animated: false)
    }
    
    func nav(tab: MainTab) -> UINavigationController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(title: tab.title, image: tab.image, tag: tab.tag)
        
        startFlow(tab: tab, nav: nav)
        
        if tab != .home, let rootVC = nav.viewControllers.first {
            nav.navigationBar.prefersLargeTitles = true
            rootVC.title = tab.title
        }
        
        return nav
    }
    
}
