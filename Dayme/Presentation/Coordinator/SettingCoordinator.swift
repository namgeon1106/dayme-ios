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
        case .logout, .userDeleted:
            parent?.trigger(with: event)
            
        case .termsNeeded(let terms):
            pushTermsDetailScreen(terms)
            
        case .termsCanceled:
            popViewController(animated: true)
            
        default:
            break
        }
    }
    
}

// MARK: - Navigate

private extension SettingCoordinator {
    
    func pushTermsDetailScreen(_ terms: Terms) {
        let termsDetailVC = TermsDetailVC(terms: terms)
        termsDetailVC.coordinator = self
        termsDetailVC.naviBarHiddenOnAppear = true
        termsDetailVC.naviBarHiddenOnDisappear = false
        termsDetailVC.hidesBottomBarWhenPushed = true
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.pushViewController(termsDetailVC, animated: true)
    }
    
}
