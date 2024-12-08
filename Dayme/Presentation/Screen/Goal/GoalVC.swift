//
//  GoalVC.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import UIKit
import FlexLayout
import PinLayout

#Preview {
    UINavigationController(rootViewController: GoalVC())
}

final class GoalVM: ObservableObject {
    @Published var isMenuHidden: Bool = true
}

final class GoalVC: VC {
    
    private let vm = GoalVM()
    private let service = GoalService()
    
    
    // MARK: UI properties
    
    private let titleLbl = UILabel("주요목표 리스트").then {
        $0.textColor(.colorDark100)
            .font(.pretendard(.semiBold, 16))
    }
    
    private let floatingBtn = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 30,
            weight: .medium
        )
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        var config = UIButton.Configuration.filled()
        config.image = image
        config.background.cornerRadius = 29
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .colorMain1
        $0.configuration = config
        $0.addShadow(.button)
    }
    
    private let dimmedView = UIButton().then {
        $0.backgroundColor = .colorDarkA25
        $0.alpha = 0
    }
    
    private let tabBarDimmedView = UIButton().then {
        $0.backgroundColor = .colorDarkA25
        $0.alpha = 0
    }
    
    private let menu = GoalFloatingMenu().then {
        $0.backgroundColor = .colorBackground
        $0.layer.cornerRadius = 12
        $0.alpha = 0
    }
    
    private let pageVC = GoalPageVC()
    
    
    // MARK: Helpers
    
    override func setup() {
        view.backgroundColor = .colorBackground
        navigationItem.leftBarButtonItem = .init(customView: titleLbl)
        menu.menuDelegate = self
    }
    
    override func setupAction() {
        floatingBtn.onAction { [weak self] in
            guard let self else { return }
            await !vm.isMenuHidden ? hideMenu() : showMenu()
        }
        
        [dimmedView, tabBarDimmedView].forEach {
            $0.onAction { [weak self] in
                await self?.hideMenu()
            }
        }
    }
    
    override func setupFlex() {
        addChild(pageVC)
        
        view.addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem(pageVC.view)
                .all(0)
                .position(.absolute)
            
            flex.addItem(dimmedView)
                .width(100%).height(100%)
                .position(.absolute)
            
            flex.addItem(menu)
                .width(142)
                .right(24).bottom(102)
                .position(.absolute)
            
            flex.addItem(floatingBtn)
                .size(CGSize(width: 58, height: 58))
                .right(24).bottom(24)
                .position(.absolute)
        }
        
        pageVC.didMove(toParent: self)
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        pageVC.view.flex.top(safeArea.top)
            .bottom(window?.safeAreaInsets.bottom ?? 0)
        flexView.flex.layout()
    }
    
    private func showMenu() async {
        Haptic.impact(.medium)
        
        vm.isMenuHidden = false
        
        if tabBarDimmedView.superview == nil,
            let tabBar = tabBarController?.tabBar {
            tabBar.addSubview(tabBarDimmedView)
            tabBarDimmedView.frame = tabBar.bounds
        }
        
        await UIView.animate(0.3, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.dimmedView.alpha = 1
            self.tabBarDimmedView.alpha = 1
            self.menu.alpha = 1
            self.floatingBtn.configuration?.baseBackgroundColor = .colorDark100
            self.floatingBtn.transform = .identity.rotated(by: -.pi / 4)
        }
    }
    
    private func hideMenu() async {
        vm.isMenuHidden = true
        
        await UIView.animate(0.3, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.dimmedView.alpha = 0
            self.tabBarDimmedView.alpha = 0
            self.menu.alpha = 0
            self.floatingBtn.configuration?.baseBackgroundColor = .colorMain1
            self.floatingBtn.transform = .identity
        }
        
        if tabBarDimmedView.superview != nil {
            tabBarDimmedView.removeFromSuperview()
        }
    }
    
}

// MARK: - GoalFloatingMenuDelegate

extension GoalVC: GoalFloatingMenuDelegate {
    
    func goalFloatingMenuDidSelect(item: GoalFloatingMenuItem) {
        Task { await hideMenu() }
        Haptic.impact(.light)
        
        switch item {
        case .goal:
            coordinator?.trigger(with: .goalAddNeeded)
        case .subGoal: break
        case .checklist: break
        }
    }
    
}
