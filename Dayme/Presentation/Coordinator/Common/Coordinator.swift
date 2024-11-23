//
//  Coordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

class Coordinator {
    
    weak var parent: Coordinator?
    
    var nav: UINavigationController
    var children: [Coordinator] = []
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    deinit {
        Logger.debug { "\(type(of: self)) \(#function)" }
    }
    
    func start() {}
    func trigger(with event: FlowEvent) {
        Logger.debug { "\(type(of: self)) \(#function)" }
    }
    
}

extension Coordinator {
    
    func startFlow(_ child: Coordinator) {
        child.parent = self
        children.append(child)
        child.start()
    }
    
}
