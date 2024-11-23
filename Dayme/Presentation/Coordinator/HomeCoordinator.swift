//
//  HomeCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/24/24.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    override func start() {
        nav.viewControllers = [UIViewController()]
    }
    
}
