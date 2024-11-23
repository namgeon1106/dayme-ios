//
//  SettingVC.swift
//  Dayme
//
//  Created by 정동천 on 11/24/24.
//

import UIKit
import FlexLayout
import PinLayout

#Preview { SettingVC() }

final class SettingVC: VC {
    
    // MARK: UI properties
    
    private let logoutBtn = FilledButton("로그아웃")
    
    // MARK: Helpers
    
    override func setup() {}
    
    override func setupAction() {
        logoutBtn.onAction { [weak coordinator] in
            Keychain.delete(key: Env.Keychain.accessTokenKey)
            Keychain.delete(key: Env.Keychain.refreshTokenKey)
            coordinator?.trigger(with: .logout)
            Haptic.noti(.success)
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.flex.addItem(logoutBtn).height(56)
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex
            .alignItems(.center)
            .justifyContent(.center)
            .layout()
    }
    
}
