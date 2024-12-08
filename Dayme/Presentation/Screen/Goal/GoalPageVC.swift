//
//  GoalPageVC.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import UIKit
import Combine
import FlexLayout
import PinLayout

#Preview { GoalPageVC() }

final class GoalPageVM: ObservableObject {
    @Published var ongoingGoals: [Goal] = []
    @Published var pastGoals: [Goal] = []
}

final class GoalPageVC: VC {
    
    private let vm = GoalPageVM()
    
    private var currentIndex: Int = 0
    
    private lazy var pageVC = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    ).then {
        $0.dataSource = self
        $0.delegate = self
        $0.setViewControllers([ongoingVC], direction: .forward, animated: false)
    }
    private let ongoingVC = GoalListVC()
    private let pastVC = GoalListVC()
    private let ongoingBtn = UIButton()
    private let pastBtn = UIButton()
    private let indicator = UIView()
    
    private var pageVCs: [UIViewController] {
        [ongoingVC, pastVC]
    }
    private var menuBtns: [UIButton] {
        [ongoingBtn, pastBtn]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.vm.ongoingGoals = mockGoals
            self.vm.pastGoals = (1...10).flatMap { _ in mockGoals }
        }
    }
    
    // MARK: Helpers
    
    override func setup() {
        updateMenuButtons()
        
        for subview in pageVC.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                return
            }
        }
    }
    
    override func setupAction() {
        menuBtns.forEach {
            $0.addTarget(self, action: #selector(menuButtonDidTap), for: .touchUpInside)
        }
    }
    
    override func setupFlex() {
        addChild(pageVC)
        
        view.addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem().direction(.row).height(44).define { flex in
                flex.addItem(ongoingBtn).marginLeft(24).padding(0, 10)
                
                flex.addItem(pastBtn).padding(0, 10)
                
                // Separator
                flex.addItem().backgroundColor(.colorGrey20)
                    .horizontally(0).bottom(0).height(1)
                    .position(.absolute)
                
                // Indicator
                flex.addItem(indicator).backgroundColor(.colorDark100)
                    .left(0).width(0).bottom(0).height(3)
                    .position(.absolute)
            }
            
            flex.addItem(pageVC.view)
        }
        
        pageVC.didMove(toParent: self)
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
    override func bind() {
        Publishers.CombineLatest(vm.$ongoingGoals, vm.$pastGoals)
            .receive(on: RunLoop.main)
            .sink { [weak self] ongoing, past in
                self?.updateGoals(ongoing: ongoing, past: past)
            }.store(in: &cancellables)
    }
    
    @objc private func menuButtonDidTap(_ button: UIButton) {
        guard let index = menuBtns.firstIndex(of: button),
              index != currentIndex else {
            return
        }
        
        indicator.flex.left(button.frame.origin.x)
            .width(button.frame.width)
        indicator.flex.markDirty()
        UIView.animate(withDuration: 0.3) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        
        pageVC.setViewControllers(
            [pageVCs[index]],
            direction: index > currentIndex ? .forward : .reverse,
            animated: true
        )
        currentIndex = index
        updateMenuButtons()
    }
    
    private func updateMenuButtons() {
        for (index, button) in menuBtns.enumerated() {
            button.alpha = index == currentIndex ? 1 : 0.4
        }
    }
    
    private func updateIndicator(progress: CGFloat = 0) {
        let direction = progress > 0 ? 1 : progress < 0 ? -1 : 0
        let targetIndex = currentIndex + direction

        // 유효한 인덱스 범위를 벗어난 경우 종료
        if targetIndex < 0 || targetIndex >= menuBtns.count {
            return
        }

        let interpolationRatio = abs(progress)
        let currentButton = menuBtns[currentIndex]
        let targetButton = menuBtns[targetIndex]

        // 인디케이터 너비 계산
        let currentButtonWidth = currentButton.frame.width * (1 - interpolationRatio)
        let targetButtonWidth = targetButton.frame.width * interpolationRatio
        let indicatorWidth = currentButtonWidth + targetButtonWidth

        // 인디케이터 X 좌표 계산
        let currentButtonX = currentButton.frame.origin.x * (1 - interpolationRatio)
        let targetButtonX = targetButton.frame.origin.x * interpolationRatio
        let indicatorX = currentButtonX + targetButtonX

        // 인디케이터 레이아웃 업데이트
        indicator.flex.left(indicatorX).width(indicatorWidth)
        indicator.flex.markDirty()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func updateGoals(ongoing: [Goal], past: [Goal]) {
        ongoingVC.goals = ongoing
        pastVC.goals = past
        
        var attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.pretendard(.semiBold, 16),
            .foregroundColor: UIColor.colorDark100
        ]
        let ongoingTitle = NSMutableAttributedString(string: "진행중 ", attributes: attributes)
        attributes[.foregroundColor] = UIColor.colorMain1
        ongoingTitle.append(.init(string: "\(ongoing.count)", attributes: attributes))
        
        ongoingBtn.setAttributedTitle(ongoingTitle, for: .normal)
        
        attributes[.foregroundColor] = UIColor.colorDark100
        
        let pastTitle = NSAttributedString(string: "지난 목표 \(past.count)", attributes: attributes)
        pastBtn.setAttributedTitle(pastTitle, for: .normal)
        
        ongoingBtn.flex.markDirty()
        pastBtn.flex.markDirty()
        updateIndicator()
        view.setNeedsLayout()
    }
    
}

// MARK: - UIPageViewControllerDataSource

extension GoalPageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pageVCs.lastIndex(of: viewController), index > 0 {
            return pageVCs[index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pageVCs.firstIndex(of: viewController),
           index < (pageVCs.count - 1) {
            return pageVCs[index + 1]
        }
        return nil
    }
    
}

// MARK: - UIPageViewControllerDelegate

extension GoalPageVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentVC = pageVC.viewControllers?.first,
           let index = pageVCs.firstIndex(of: currentVC) {
            currentIndex = index
            updateMenuButtons()
        }
    }
    
}

// MARK: - UIScrollViewDelegate

extension GoalPageVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let offsetX = scrollView.contentOffset.x - width
        if width > 0 {
            updateIndicator(progress: offsetX / width)
        }
    }
    
}
