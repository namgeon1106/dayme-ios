//
//  SplashVC.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import UIKit
import FlexLayout
import PinLayout

#if DEBUG
#Preview { SplashVC() }
#endif

final class SplashVC: VC {
    
    private let userService: UserService = .shared
    
    // MARK: UI properties
    
    private let logo = UIImageView(image: .icLogo)
    
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task { await validateUser() }
    }
    
    
    // MARK: Helpers
    
    override func setup() {
        view.backgroundColor = .colorBackground
    }
    
    override func setupFlex() {
        view.addSubview(logo)
    }
    
    override func layoutFlex() {
        logo.pin.bottom(view.bounds.height / 2).hCenter()
    }
    
    @MainActor
    private func validateUser() async {
        do {
            try await userService.getUser()
            coordinator?.trigger(with: .loginFinished)
        } catch {
            Logger.error(error)
            coordinator?.trigger(with: .logout)
        }
    }
    
}
