//
//  ViewController.swift
//  Dayme
//
//  Created by 정동천 on 11/1/24.
//

import UIKit
import Combine

class VC: UIViewController {
    
    weak var coordinator: Coordinator?
    
    let flexView = UIView()
    
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        Logger.debug { "\(type(of: self)) \(#function)" }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupAction()
        setupFlex()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutFlex()
    }
    
    // MARK: - Helpers
    
    func setup() {}
    func setupAction() {}
    func setupFlex() {}
    func layoutFlex() {}
    func bind() {}
    
    // MARK: - Keyboard Obeserver
    
    func keyboardWillShow(_ height: CGFloat) {}
    func keyboardWillHide() {}
    
    final func addKeyboardObeserver() {
        let showSelector = #selector(keyboardWillShow(notification:))
        let hideSelector = #selector(keyboardWillHide(notification:))
        let showName = UIResponder.keyboardWillShowNotification
        let hideName = UIResponder.keyboardDidHideNotification
        let notiCenter = NotificationCenter.default
        
        notiCenter.addObserver(self, selector: showSelector, name: showName, object: nil)
        notiCenter.addObserver(self, selector: hideSelector, name: hideName, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let height = keyboardHeight(notification)
        keyboardWillShow(height)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        keyboardWillHide()
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let keyboardInfoKey = UIResponder.keyboardFrameEndUserInfoKey
        let rect = (notification.userInfo?[keyboardInfoKey] as? NSValue)?.cgRectValue
        return rect?.height ?? 0
    }
    
}
