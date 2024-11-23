//
//  MainCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    override func start() {
        let mainTC = MainTC()
        nav.viewControllers = [mainTC]
    }
    
}
