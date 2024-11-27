//
//  Coordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

class Coordinator: NSObject, UIGestureRecognizerDelegate {
    
    weak var parent: Coordinator?
    
    var nav: UINavigationController
    var children: [Coordinator] = []
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    deinit {
        Logger.debug { "\(type(of: self)) \(#function)" }
    }
    
    func start(animated: Bool) {}
    func trigger(with event: FlowEvent) {
        Logger.debug { "\(type(of: self)) \(#function)" }
    }
    
}

extension Coordinator {
    
    func startFlow(_ child: Coordinator, animated: Bool) {
        child.parent = self
        children.append(child)
        child.start(animated: animated)
    }
    
    func addFadeTransaction(in layer: CALayer) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        nav.view.layer.add(transition, forKey: kCATransition)
    }
    
    func popViewController(animated: Bool) {
        nav.popViewController(animated: animated)
    }
    
}
