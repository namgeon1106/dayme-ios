//
//  VC.swift
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
    var naviBarHiddenOnAppear: Bool?
    var naviBarHiddenOnDisappear: Bool?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let naviBarHiddenOnAppear {
            navigationController?.setNavigationBarHidden(naviBarHiddenOnAppear, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let naviBarHiddenOnDisappear {
            navigationController?.setNavigationBarHidden(naviBarHiddenOnDisappear, animated: true)
        }
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

extension VC {
    
    static func naviBackButton() -> UIButton {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .colorGrey30
        return button
    }
    
    func setNaviTitle(_ title: String) {
        self.title = title
        if let naviBar = navigationController?.navigationBar {
            var attributes = naviBar.titleTextAttributes.orEmpty
            attributes[.foregroundColor] = UIColor.colorDark100
            attributes[.font] = UIFont.pretendard(.semiBold, 16)
            naviBar.titleTextAttributes = attributes
        }
    }
    
    func showAlert(title: String, message: String) {
        Haptic.noti(.warning)
        
        Alert(title: title, message: message)
            .onAction(title: "확인")
            .show(on: self)
    }
    
}
