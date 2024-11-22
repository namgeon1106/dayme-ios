//
//  Loader.swift
//  Dayme
//
//  Created by 정동천 on 11/22/24.
//

import UIKit
import JGProgressHUD

final class Loader {
    
    private static let hud = JGProgressHUD(style: .dark)
    
    private init() {}
    
    class func show(in view: UIView, delay: TimeInterval = .zero) {
        hud.show(in: view, animated: true, afterDelay: delay)
    }
    
    class func dismiss(delay: TimeInterval = .zero, completion: (() -> Void)? = nil) {
        hud.dismiss(afterDelay: delay, animated: true, completion: completion)
    }
    
}
