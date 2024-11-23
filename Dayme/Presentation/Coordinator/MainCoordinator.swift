//
//  MainCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    override func start() {
        let navs = MainTab.allCases.map(nav)
        let mainTC = MainTC(navs)
        mainTC.coordinator = self
        nav.viewControllers = [mainTC]
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

private extension MainCoordinator {
    
    func startFlow(tab: MainTab, nav: UINavigationController) {
        let child = switch tab {
        case .home: HomeCoordinator(nav: nav)
        case .goal: GoalCoordinator(nav: nav)
        case .setting: SettingCoordinator(nav: nav)
        }
        startFlow(child)
    }
    
    func nav(tab: MainTab) -> UINavigationController {
        let nav = UINavigationController()
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(title: tab.title, image: tab.image, tag: tab.tag)
        
        startFlow(tab: tab, nav: nav)
        
        if let rootVC = nav.viewControllers.first {
            rootVC.title = tab.title
        }
        
        return nav
    }
    
}
