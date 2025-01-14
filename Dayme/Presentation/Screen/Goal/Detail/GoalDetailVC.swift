//
//  GoalDetailVC.swift
//  Dayme
//
//  Created by 정동천 on 12/12/24.
//

import UIKit
import Combine
import FlexLayout
import PinLayout

#if DEBUG
#Preview {
    let vm = GoalDetailVM(goal: mockGoals[0])
    let vc = GoalDetailVC(vm: vm)
    return UINavigationController(rootViewController: vc)
}
#endif

final class GoalDetailVC: VC {
    
    private let vm: GoalDetailVM
    
    // MARK: UI properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backBtn = naviBackButton()
    
    // 주요 목표
    private let goalProgressBar = ProgressBar().then {
        $0.backgroundColor = .colorGrey10
        $0.showIndicator = true
    }
    private let goalEmojiLbl = UILabel().then {
        $0.font(.pretendard(.semiBold, 32))
    }
    private let goalTitleLbl = UILabel().then {
        $0.textColor(.colorDark100)
        $0.font(.pretendard(.medium, 18))
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    private let goalDateLbl = UILabel().then {
        $0.textColor(.colorGrey50)
        $0.font(.pretendard(.medium, 14))
        $0.lineBreakMode = .byTruncatingTail
    }
    
    // 세부 목표
    private let subgoalSection = SubgoalSection()
    
    // 체크리스트
    private lazy var checklistSection = ChecklistSection(goal: vm.goal)
    
    // 홈 화면 표시
    private let homeSubtitleLbl = UILabel("홈 화면 표시").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    private let homeCaptionLbl = UILabel("홈에 표시").then {
        $0.textColor(.colorDark100).font(.pretendard(.medium, 16))
    }
    private let homeSwitch = UISwitch().then {
        $0.onTintColor = .colorMain1
    }
    private let homeContainer = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = .uiColor(.colorGrey20)
    }
    private let homeWarningLbl = UILabel("홈 화면에는 목표가 최대 3개까지만 표시됩니다.").then {
        $0.textColor(.colorRed)
        $0.font(.pretendard(.medium, 14))
        $0.alpha = 0
    }
    
    // MARK: - onboarding UI
    private let onboardingBackgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private let onboardingEmptySubgoalView = OnboardingFocusedView(
        message: "세부 목표가 설정되지 않았어요.\n세부목표를 정하고 목표를 관리해보세요!",
        buttonTitle: "세부목표 작성하기",
        buttonWidth: 110
    )
    
    private let onboardingPhase4GuideView = OnboardingGuideView(
        mainMessage: "4. '세부목표'를 작성해 보세요.\n",
        subMessage: "[ 세부목표: 최종 목표를 위한 중간 단계 목표 ]"
    )
    
    private let onboardingPhase4_1GuideView = OnboardingGuideView(
        mainMessage: "4-1. '세부목표' 내용을 추가해 보세요.\n",
        subMessage: "[ 세부목표: 최종 목표를 위한 중간 단계 목표 ]"
    )
    
    private let onboardingAddSubgoalImageView = UIImageView(image: UIImage(named: "AddSubGoalPageSheet"))
    
    private let onboardingEmptyChecklistView = OnboardingFocusedView(
        message: "체크리스트가 설정되지 않았어요.\n체크리스트를 작성하고 목표를 관리해보세요.",
        buttonTitle: "체크리스트 작성하기",
        buttonWidth: 121
    )
    
    private let onboardingPhase5GuideView = OnboardingGuideView(
        mainMessage: "5. '체크리스트'를 작성해 보세요.\n",
        subMessage: "[ 체크리스트: 매일 또는 특정일에 실행해야 할 일 ]"
    )
    
    // MARK: Lifecycles
    
    init(vm: GoalDetailVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Helpers
    
    override func setup() {
        setNaviTitle("주요목표 정보")
        navigationItem.leftBarButtonItem = .init(customView: backBtn)
        view.backgroundColor = .colorBackground
        scrollView.keyboardDismissMode = .interactive
        subgoalSection.delegate = self
        checklistSection.delegate = self
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let emojiContainer = CircleView()
        emojiContainer.layer.borderColor = .uiColor(.colorGrey20)
        emojiContainer.layer.borderWidth = 2
        
        contentView.flex.define { flex in
            // 주요 목표
            flex.addItem().padding(0, 28).marginTop(32).define { flex in
                flex.addItem().direction(.row).alignItems(.center).height(60).define { flex in
                    flex.addItem(emojiContainer).justifyContent(.center).width(60).height(60).define { flex in
                        flex.addItem(goalEmojiLbl).alignSelf(.center).position(.absolute)
                    }
                    
                    flex.addItem().marginLeft(12).shrink(1).define { flex in
                        flex.addItem(goalTitleLbl)
                        
                        flex.addItem(goalDateLbl).marginTop(6)
                    }
                }
                
                flex.addItem(goalProgressBar).margin(18, 0, 24, 0).height(24)
            }
            
            flex.addItem().height(1).backgroundColor(.colorGrey20)
            
            // 세부 목표
            flex.addItem(subgoalSection)
            
            flex.addItem().height(8).backgroundColor(.colorGrey20)
            
            // 체크리스트
            flex.addItem(checklistSection)
            
            flex.addItem().height(8).backgroundColor(.colorGrey20)
            
            // 홈 표시
            flex.addItem(homeSubtitleLbl).margin(24, 24, 0, 0)
            
            flex.addItem(homeContainer).direction(.row).alignItems(.center).margin(12, 24, 0, 24).height(58).padding(0, 12).define { flex in
                flex.addItem(homeCaptionLbl)
                
                flex.addItem().grow(1)
                
                flex.addItem(homeSwitch)
            }
            
            flex.addItem(homeWarningLbl).margin(15, 24, 20, 0)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.pin.width(of: scrollView)
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.bounds.size
        
        tabBarController?.view.addSubview(onboardingBackgroundView)
        onboardingBackgroundView.pin.all()
        [
            onboardingEmptySubgoalView,
            onboardingPhase4GuideView,
            onboardingAddSubgoalImageView,
            onboardingPhase4_1GuideView,
            onboardingEmptyChecklistView,
            onboardingPhase5GuideView
        ].forEach(onboardingBackgroundView.addSubview(_:))
        
        onboardingEmptySubgoalView.pin
            .top(to: subgoalSection.edge.top)
            .marginTop(79)
            .horizontally(24)
            .height(120)
        
        onboardingPhase4GuideView.pin
            .top(to: subgoalSection.edge.top)
            .hCenter()
            .width(285)
            .height(88)
        
        onboardingPhase4_1GuideView.pin
            .bottom(633)
            .hCenter()
            .width(285)
            .height(88)
        
        onboardingAddSubgoalImageView.pin
            .horizontally(8)
            .bottom(72)
            .height(570)
        
        onboardingEmptyChecklistView.pin
            .top(to: checklistSection.edge.top)
            .marginTop(117)
            .horizontally(24)
            .height(120)
        
        onboardingPhase5GuideView.pin
            .bottom(to: onboardingEmptyChecklistView.edge.bottom)
            .marginBottom(110)
            .height(85)
            .hCenter()
            .width(305)
    }
    
    override func setupAction() {
        backBtn.onAction { [weak self] in
            self?.coordinator?.trigger(with: .goalDetailCanceled)
        }
        
        homeSwitch.onAction(for: .valueChanged) { [weak self] in
            guard let self else { return }
            
            if vm.isDisplayLimited {
                homeSwitch.isOn = false
                homeContainer.layer.borderColor = .uiColor(.colorRed)
                homeWarningLbl.alpha = 1
                Haptic.noti(.warning)
            } else {
                await toggleDisplayHome()
            }
        }
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(progressOnboardingPhase))
        
        onboardingBackgroundView.addGestureRecognizer(tapGesture)
    }
    
    override func bind() {
        vm.$goal.receive(on: RunLoop.main)
            .sink { [weak self] goal in
                self?.updateGoal(goal)
            }.store(in: &cancellables)
        
        vm.$onboardingPhase.receive(on: RunLoop.main)
            .sink { [weak self] onboardingPhase in
                self?.onboardingBackgroundView.isHidden = onboardingPhase == nil
                
                self?.onboardingEmptySubgoalView.isHidden = onboardingPhase != .phase4
                self?.onboardingPhase4GuideView.isHidden = onboardingPhase != .phase4
                
                self?.onboardingAddSubgoalImageView.isHidden = onboardingPhase != .phase4_1
                self?.onboardingPhase4_1GuideView.isHidden = onboardingPhase != .phase4_1
                
                self?.onboardingEmptyChecklistView.isHidden = onboardingPhase != .phase5
                self?.onboardingPhase5GuideView.isHidden = onboardingPhase != .phase5
            }.store(in: &cancellables)
    }
    
    private func updateGoal(_ goal: Goal) {
        let startDate = goal.startDate.string(style: .dotted)
        let endDate = goal.endDate.string(style: .dotted)
        goalEmojiLbl.text = goal.emoji
        goalTitleLbl.text = goal.title
        goalDateLbl.text = "\(startDate) ~ \(endDate)"
        goalProgressBar.progress = goal.progress
        goalProgressBar.tintColor = .hex(goal.hex)
        homeSwitch.isOn = goal.displayHome
        
        subgoalSection.update(subgoals: goal.subgoals)
        
        checklistSection.update(goal: goal)
        
        goalEmojiLbl.flex.markDirty()
        goalTitleLbl.flex.markDirty()
        goalDateLbl.flex.markDirty()
        
        view.setNeedsLayout()
    }
    
    @MainActor
    private func toggleDisplayHome() async {
        do {
            try await vm.toggleDisplayHome()
        } catch {
            homeSwitch.isOn = vm.goal.displayHome
            showAlert(title: "🚨 홈화면 표시 변경 실패", message: error.localizedDescription)
        }
    }
    
    @MainActor
    private func toggleChecklist(_ history: Checklist.History) async {
        do {
            try await vm.toggleChecklist(history)
        } catch {
            showAlert(title: "🚨 체크리스트 상태 변경 실패", message: error.localizedDescription)
        }
    }
    
    deinit {
        onboardingBackgroundView.removeFromSuperview()
    }
}

// MARK: - SubgoalSectionDelegate

extension GoalDetailVC: SubgoalSectionDelegate {
    
    func subgoalSectionDidTapAddButton() {
        coordinator?.trigger(with: .subgoalAddNeeded(vm.goal))
    }
    
    func subgoalSectionDidTapEditButton(_ subgoal: Subgoal) {
        coordinator?.trigger(with: .subgoalEditNeeded(goal: vm.goal, subgoal: subgoal))
    }
    
}

// MARK: - ChecklistSectionDelegate

extension GoalDetailVC: ChecklistSectionDelegate {
    
    func checklistSectionDidTapAddButton(subgoal: Subgoal?) {
        coordinator?.trigger(with: .checklistAddNeeded(goal: vm.goal, subgoal: subgoal))
    }
    
    func checklistSectionDidTapEditButton(_ checklist: Checklist) {
        let subgoal = vm.goal.subgoals.first(where: { $0.checklists.contains(checklist) })
        coordinator?.trigger(with: .checklistEditNeeded(goal: vm.goal, subgoal: subgoal, checklist: checklist))
    }
    
    func checklistSectionDidTapCheckButton(_ checklist: Checklist) {
        if let history = checklist.currentHistory {
            Haptic.impact(.light)
            Task { await toggleChecklist(history) }
        }
    }
    
    func checklistSectionDidUpdateLayout() {
        view.setNeedsLayout()
    }
    
}

// MARK: - onboarding action
extension GoalDetailVC {
    @objc
    private func progressOnboardingPhase() {
        vm.progressOnboardingPhase()
        coordinator?.trigger(with: .onboarding4Finished)
        
    }
}
