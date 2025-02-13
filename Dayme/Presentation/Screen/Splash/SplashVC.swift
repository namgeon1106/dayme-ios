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
    private let deviceManager: DeviceManager = .shared
    
    // MARK: UI properties
    
    private let logo = UIImageView(image: .icLogo)
    private let timo = UIImageView(image: .timoFace)
    
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            if await checkVersion() {
                await validateUser()
            }
        }
    }
    
    
    // MARK: Helpers
    
    override func setup() {
        view.backgroundColor = .colorMain1
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        
        flexView.flex
            .alignItems(.center)
            .justifyContent(.center)
            .define { flex in
                flexView.flex.define { flex in
                    flex.addItem(timo).width(126).height(126)
                    
                    flex.addItem(logo).margin(15, 0, 40)
                }
            }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
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
    
    @MainActor
    private func checkVersion() async -> Bool {
        do {
            if try await deviceManager.checkVersion() {
                return true
            }
            
            let title = "🛠️ 업데이트 알림"
            let message = "안정적인 서비스 제공을 위해\n최신 버전으로 업그레이드가 필요합니다."
            
            await CustomConfirmAlert(title: title, message: message, primaryTitle: "확인", isCancellable: false)
                .show(on: window!)
            
            let appId = Env.appId
            if let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/\(appId)") {
                await UIApplication.shared.open(appStoreURL)
            }
        } catch {
            Logger.error(error)
        }
        
        return false
    }
    
}
