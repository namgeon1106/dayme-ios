//
//  Alert.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

class Alert {
    
    let title: String
    let message: String
    private(set) var cancelAction: UIAlertAction?
    private(set) var defaultAction: UIAlertAction?
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    func onCancel(title: String, handler: (() -> Void)? = nil) -> Self {
        cancelAction = UIAlertAction(title: title, style: .cancel) { _ in
            handler?()
        }
        return self
    }
    
    func onAction(title: String, handler: (() -> Void)? = nil) -> Self {
        defaultAction = UIAlertAction(title: title, style: .default) { _ in
            handler?()
        }
        return self
    }
    
    func show(on viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: "\n\(message)", preferredStyle: .alert)
        cancelAction.map(alert.addAction)
        defaultAction.map(alert.addAction)
        viewController.present(alert, animated: true)
    }
    
}
