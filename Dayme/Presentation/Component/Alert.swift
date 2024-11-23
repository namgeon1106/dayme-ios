//
//  Alert.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

fileprivate class AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: (() -> Void)?
    
    init(title: String, style: UIAlertAction.Style, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

class Alert {
    
    let title: String
    let message: String
    
    private var cancelAction: AlertAction?
    private var defaultAction: AlertAction?
    
    private var continuation: CheckedContinuation<Void, Never>?
    
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    
    func onCancel(title: String, handler: (() -> Void)? = nil) -> Self {
        cancelAction = AlertAction(title: title, style: .cancel) {
            handler?()
        }
        return self
    }
    
    func onAction(title: String, handler: (() -> Void)? = nil) -> Self {
        defaultAction = AlertAction(title: title, style: .default) {
            handler?()
        }
        return self
    }
    
    func show(on viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: "\n\(message)", preferredStyle: .alert)
        
        for action in [cancelAction, defaultAction].compactMap({ $0 }) {
            let alertAction = alertAction(action)
            alert.addAction(alertAction)
        }
        
        viewController.present(alert, animated: true)
    }
    
    @MainActor
    func show(on viewController: UIViewController) async {
        let alert = UIAlertController(title: title, message: "\n\(message)", preferredStyle: .alert)
        
        return await withCheckedContinuation { [weak self] continuation in
            guard let self else { return }
            
            self.continuation = continuation
            
            for action in [cancelAction, defaultAction].compactMap({ $0 }) {
                let alertAction = alertAction(action) {
                    continuation.resume()
                }
                alert.addAction(alertAction)
            }
            
            viewController.present(alert, animated: true)
        }
    }
    
    private func alertAction(_ action: AlertAction, completion: (() -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: action.title, style: action.style) { _ in
            action.handler?()
            completion?()
        }
    }
    
}
