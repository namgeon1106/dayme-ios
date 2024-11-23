//
//  MainTC.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

enum MainTab: Int, CaseIterable {
    case home, goal, setting
    
    var tag: Int { rawValue }
    
    var title: String {
        return switch self {
        case .home: "홈"
        case .goal: "목표관리"
        case .setting: "설정"
        }
    }
    
    var image: UIImage {
        return switch self {
        case .home: .icTabHome
        case .goal: .icTabGoal
        case .setting: .icTabSetting
        }
    }
}

final class MainTC: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.viewControllers = MainTab.allCases.map(viewController)
        self.selectedIndex = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func viewController(_ tab: MainTab) -> UIViewController {
        let vc = UIViewController()
        vc.title = tab.title
        vc.tabBarItem = UITabBarItem(title: tab.title, image: tab.image, tag: tab.tag)
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.prefersLargeTitles = true
        return nc
    }
    
}
