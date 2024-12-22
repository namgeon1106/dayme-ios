//
//  HomeVC.swift
//  Dayme
//
//  Created by 정동천 on 12/4/24.
//

import UIKit
import FlexLayout
import PinLayout
import Combine

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
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.define { flex in
            flex.addItem(dashboard).margin(15)
            
            flex.addItem(dateGroupView).marginTop(15)
            
            flex.addItem(checklistCardList).marginVertical(20).height(294)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.bounds.size
    }
    
    override func bind() {
        vm.$nickname.receive(on: RunLoop.main)
            .sink { [weak self] nickname in
                self?.nicknameLbl.text = "\(nickname)님"
                self?.dashboard.update(nickname: nickname)
            }.store(in: &cancellables)
        
        vm.$nickname.combineLatest(vm.$goals)
            .receive(on: RunLoop.main)
            .sink { [weak self] nickname, goals in
                self?.dashboard.update(nickname: nickname, goals: goals)
                self?.view.setNeedsLayout()
            }.store(in: &cancellables)
        
        
        vm.$selectedDate.combineLatest(vm.$weekDates)
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedDate, weekDates in
                self?.dateGroupView.updateWeekDates(selectedDate: selectedDate, weekDates: weekDates)
            }.store(in: &cancellables)
        
        vm.$checklistDateItems.receive(on: RunLoop.main)
            .sink { [weak self] items in
                self?.checklistCardList.items = items
                
                for item in items {
                    let checklists = item.checklists
                    Logger.debug("\(item.goal.title) - \(checklists)")
                }
            }.store(in: &cancellables)
    }
    
}

extension HomeVC {
    
    @MainActor
    private func toggleChecklist(goalId: Int, historyId: Int) async {
        do {
            try await vm.toggleChecklist(goalId: goalId, historyId: historyId)
        } catch {
            showAlert(title: "🚨 체크리스트 상태 변경 실패", message: error.localizedDescription)
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
    
    func homeChecklistCardRowDidCheck(goal: Goal, checklist: Checklist) {
        if let history = checklist.currentHistory {
            Haptic.impact(.light)
            Task { await toggleChecklist(goalId: goal.id, historyId: history.id) }
        }
    }
    
}
