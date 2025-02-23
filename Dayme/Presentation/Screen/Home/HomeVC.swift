//
//  HomeVC.swift
//  Dayme
//
//  Created by 정동천 on 12/4/24.
//

import Combine
import FlexLayout
import PinLayout
import Then
import UIKit

#if DEBUG
    #Preview {
        UINavigationController(rootViewController: HomeVC())
    }
#endif

final class HomeVC: VC {

    private let vm = HomeVM()

    // MARK: UI Properties

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let dashboard = HomeDashboard()
    private let dateGroupView = HomeDateGroupView()
    private let checklistCardList = HomeChecklistCardList()
    private let goalListEmptyView = GoalListEmptyView()

    private let onboardingBackgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }

    private let onboardingGoalListEmptyView = GoalListEmptyView().then {
        $0.backgroundColor = .colorSnow
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }

    private let logo = UILabel("DAYME").then {
        $0.textColor(.colorMain1)
            .font(.montserrat(.black, 20))
    }

    private let userSV = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }

    private let nicknameLbl = UILabel().then {
        $0.textColor(.colorGrey50)
            .font(.pretendard(.semiBold, 16))
    }

    private let profileIV = UIImageView(image: .icProfileDefault)

    private let onboardingGuideView = OnboardingGuideView(
        message: "1. '목표 만들기'를\n    클릭해서 목표를 설정해 보세요!",
        tailOffset: -8
    )

    // MARK: Helpers

    override func setup() {
        view.backgroundColor = .colorSnow
        userSV.addArrangedSubview(nicknameLbl)
        userSV.addArrangedSubview(profileIV)
        navigationItem.leftBarButtonItem = .init(customView: logo)
        navigationItem.rightBarButtonItem = .init(customView: userSV)
        scrollView.showsVerticalScrollIndicator = false
        dashboard.delegate = self
        dateGroupView.delegate = self
        checklistCardList.cardDelegate = self
        goalListEmptyView.delegate = self

        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(didTapOnboardingGuide))
        
        onboardingBackgroundView.addGestureRecognizer(tapGesture)
    }

    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        tabBarController?.view.addSubview(onboardingBackgroundView)

        [
            onboardingGoalListEmptyView,
            onboardingGuideView,
        ]
        .forEach(onboardingBackgroundView.addSubview(_:))

        contentView.flex.define { flex in
            flex.addItem(dashboard).margin(15)

            flex.addItem(dateGroupView).marginTop(15)

            flex.addItem(checklistCardList).marginVertical(20).height(294)
        }
        
        contentView.addSubview(goalListEmptyView)
    }

    override func layoutFlex() {
        flexView.pin.all()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.bounds.size

        onboardingBackgroundView.pin.all()
        goalListEmptyView.pin
            .top(to: checklistCardList.edge.top)
            .left(to: checklistCardList.edge.left)
            .right(to: checklistCardList.edge.right)
            .bottom(to: checklistCardList.edge.bottom)

        onboardingGoalListEmptyView.pin
            .top(to: dateGroupView.edge.bottom)
            .bottom(to: view.edge.bottom)
            .marginTop(100)
            .height(133)
            .horizontally(24)

        onboardingGuideView.pin
            .width(227)
            .hCenter(8)
            .top(to: onboardingGoalListEmptyView.edge.top)
            .marginTop(-74)
            .height(83)

    }

    override func bind() {
        vm.$nickname.receive(on: RunLoop.main)
            .sink { [weak self] nickname in
                self?.nicknameLbl.text = "\(nickname)님"
                self?.dashboard.update(nickname: nickname)
            }.store(in: &cancellables)
        
        vm.$nickname
            .combineLatest(vm.$goals)
            .combineLatest(vm.$finishedOnboarding)
            .receive(on: RunLoop.main)
            .sink { [weak self] tuple, finishedOnboarding in
                let nickname = tuple.0
                let goals = tuple.1
                
                if finishedOnboarding {
                    self?.dashboard.update(nickname: nickname, goals: goals)
                    
                    var items = [ChecklistDateItem?]()
                    for goal in goals {
                        for subgoal in goal.subgoals {
                            items.append(
                                ChecklistDateItem(
                                    subgoal: subgoal,
                                    goalId: goal.id,
                                    goalEmoji: goal.emoji,
                                    goalTitle: goal.title,
                                    hex: goal.hex,
                                    date: .now
                                )
                            )
                        }
                    }
                    self?.checklistCardList.items = items.compactMap { $0 }
                }
                self?.goalListEmptyView.isHidden = !goals.isEmpty
                self?.view.setNeedsLayout()
            }.store(in: &cancellables)

        vm.$selectedDate.combineLatest(vm.$weekDates)
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedDate, weekDates in
                self?.dateGroupView.updateWeekDates(
                    selectedDate: selectedDate, weekDates: weekDates)
            }.store(in: &cancellables)

        vm.$checklistDateItems.receive(on: RunLoop.main)
            .sink { [weak self] items in
                self?.checklistCardList.items = items

                for item in items {
                    let checklists = item.checklists
                    Logger.debug("\(item.goalTitle) - \(checklists)")
                }
            }.store(in: &cancellables)

        vm.$finishedOnboarding
            .sink { [weak self] finishedOnboarding in
                self?.onboardingBackgroundView.isHidden = finishedOnboarding
                
                self?.checklistCardList.isHidden = !finishedOnboarding
            }.store(in: &cancellables)
    }
    
    deinit {
        onboardingBackgroundView.removeFromSuperview()
    }
}

extension HomeVC {
    @MainActor
    private func toggleChecklist(goalId: Int, historyId: Int) async {
        do {
            try await vm.toggleChecklist(goalId: goalId, historyId: historyId)
        } catch {
            if error.localizedDescription == "만료된 토큰입니다." {
                do {
                    try await AuthService().refreshToken()
                    try await vm.toggleChecklist(goalId: goalId, historyId: historyId)
                } catch {
                    showAlert(title: "🚨 체크리스트 상태 변경 실패", message: error.localizedDescription)
                    if error.localizedDescription == "만료된 토큰입니다." {
                        coordinator?.parent?.trigger(with: .logout)
                    }
                }
            } else {
                showAlert(
                    title: "🚨 체크리스트 상태 변경 실패", message: error.localizedDescription)
            }
        }
    }

}

// MARK: - HomeDateGroupViewDelegate

extension HomeVC: HomeDashboardDelegate {
    func homeDashboardDidTapGoalButton() {
        tabBarController?.selectedIndex = 1
    }

}

// MARK: - HomeDateGroupViewDelegate

extension HomeVC: HomeDateGroupViewDelegate {

    func homeDateGroupViewDidSelectItem(date: Date) {
        vm.selectedDate = date
        Haptic.impact(.light)
    }

    func homeDateGroupViewDidTapPrev() {
        if let startDate = vm.weekDates.first {
            let prevDate = startDate.addingDays(-7)
            vm.weekDates = Calendar.current.weekDates(from: prevDate)
            Haptic.impact(.light)
        }
    }

    func homeDateGroupViewDidTapNext() {
        if let startDate = vm.weekDates.first {
            let nextDate = startDate.addingDays(7)
            vm.weekDates = Calendar.current.weekDates(from: nextDate)
            Haptic.impact(.light)
        }
    }
    
    
}

// MARK: - HomeChecklistCardRowDelegate

extension HomeVC: HomeChecklistCardRowDelegate {

    func homeChecklistCardRowDidCheck(goalId: Int, checklist: Checklist) {
        if let history = checklist.currentHistory {
            Haptic.impact(.light)
            Task {
                await toggleChecklist(goalId: goalId, historyId: history.id)
            }
        }
    }

}

// MARK: - Onboarding
extension HomeVC {
    @objc
    func didTapOnboardingGuide() {
        vm.hideOnboardingGuide()
        coordinator?.trigger(with: .onboarding1Finished)
    }
}

extension HomeVC: GoalListEmptyViewDelegate {
    func didTapAddButton() {
        coordinator?.trigger(with: .goalAddNeeded)
    }
}
