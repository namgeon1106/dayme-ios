//
//  UIViewController++.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import UIKit

extension UIViewController {
    
    var window: UIWindow? {
        UIApplication.shared.connectedScenes.first
            .flatMap { $0 as? UIWindowScene }
            .flatMap { $0.windows.first }
    }
    
    var safeArea: UIEdgeInsets {
        view.safeAreaInsets
    }
    
    var naviBar: UINavigationBar? {
        navigationController?.navigationBar
    }
    
    var naviBarSize: CGSize {
        naviBar?.frame.size ?? .zero
    }
    
    var tabBarSize: CGSize {
        tabBarController?.tabBar.frame.size ?? .zero
    }
    
}
