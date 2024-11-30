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
    
    private let userService = UserService()
    
    // MARK: UI properties
    
    private let logoutBtn = FilledButton("로그아웃")
    private let withdrawBtn = FilledButton("회원 탈퇴")
    
    // MARK: Helpers
    
    override func setupAction() {
        logoutBtn.onAction { [weak coordinator] in
            Keychain.delete(key: Env.Keychain.accessTokenKey)
            Keychain.delete(key: Env.Keychain.refreshTokenKey)
            coordinator?.trigger(with: .logout)
            Haptic.noti(.success)
        }
        
        withdrawBtn.onAction { [weak self] in
            guard let self else { return }
            
            try? await userService.deleteUser()
            
            coordinator?.trigger(with: .userDeleted)
            Haptic.noti(.success)
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.flex.addItem().alignItems(.center).define { flex in
            flex.addItem(logoutBtn).width(50%).height(56)
            flex.addItem().height(18)
            flex.addItem(withdrawBtn).width(50%).height(56)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex
            .justifyContent(.center)
            .layout()
    }
    
}
