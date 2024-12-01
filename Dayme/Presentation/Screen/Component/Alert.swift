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

final class Alert {
    
    let title: String
    let message: String
    
    private var cancelAction: AlertAction?
    private var defaultAction: AlertAction?
    private var destructiveAction: AlertAction?
    
    private var continuation: CheckedContinuation<String, Never>?
    
    
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
    
    func onDestructive(title: String, handler: (() -> Void)? = nil) -> Self {
        destructiveAction = AlertAction(title: title, style: .destructive) {
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
    
    /// 사용자가 선택한 Action의 title을 리턴합니다.
    @MainActor
    @discardableResult
    func show(on viewController: UIViewController) async -> String {
        let alert = UIAlertController(title: title, message: "\n\(message)", preferredStyle: .alert)
        
        return await withCheckedContinuation { [weak self] continuation in
            guard let self else { return }
            
            self.continuation = continuation
            
            let actions = [cancelAction, defaultAction, destructiveAction].compactMap({ $0 })
            for action in actions {
                let alertAction = alertAction(action) {
                    continuation.resume(returning: action.title)
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
