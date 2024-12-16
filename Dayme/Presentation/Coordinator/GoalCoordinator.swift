//
//  GoalCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/24/24.
//

import UIKit

final class GoalCoordinator: Coordinator {
    
    override func start(animated: Bool) {
        let goalVC = GoalVC()
        goalVC.coordinator = self
        nav.viewControllers = [goalVC]
    }
    
    override func trigger(with event: FlowEvent) {
        switch event {
        case .goalAddNeeded:
            pushGoalAddScreen()
            
        case .goalEditNeeded(let goal):
            pushGoalEditScreen(goal: goal)
            
        case .goalDetailNeeded(let goal):
            pushGoalDetailScreen(goal: goal)
            
        case .subgoalAddNeeded(let goal):
            presentSubgoalAddScreen(goal: goal)
            
        case .checklistAddNeeded(let goal, let subgoal):
            presentChecklistAddScreen(goal: goal, subgoal: subgoal)
            
        case .goalAddCanceled, .goalEditCanceled, .goalDetailCanceled:
            popViewController(animated: true)
            
        case .subgoalAddCanceled, .checklistAddCanceled:
            dismissPresentedViewController(animated: true)
            
        default: break
        }
    }
    
}

// MARK: - Navigate

private extension GoalCoordinator {
    
    func pushGoalAddScreen() {
        let goalAddVC = GoalAddVC()
        goalAddVC.coordinator = self
        goalAddVC.hidesBottomBarWhenPushed = true
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.pushViewController(goalAddVC, animated: true)
    }
    
    func pushGoalEditScreen(goal: Goal) {
        let goalEditVM = GoalEditVM(goal: goal)
        let goalEditVC = GoalEditVC(vm: goalEditVM)
        goalEditVC.coordinator = self
        goalEditVC.hidesBottomBarWhenPushed = true
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.pushViewController(goalEditVC, animated: true)
    }
    
    func pushGoalDetailScreen(goal: Goal) {
        let goalDetailVM = GoalDetailVM(goal: goal)
        let goalDetailVC = GoalDetailVC(vm: goalDetailVM)
        goalDetailVC.coordinator = self
        goalDetailVC.hidesBottomBarWhenPushed = true
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.pushViewController(goalDetailVC, animated: true)
    }
    
    func presentSubgoalAddScreen(goal: Goal) {
        let vm = SubgoalAddVM(goal: goal)
        let vc = SubgoalAddVC(vm: vm)
        vc.coordinator = self
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom { _ in vc.modalHeight }]
            sheet.preferredCornerRadius = 0
        }
        
        nav.present(vc, animated: true)
    }
    
    func presentChecklistAddScreen(goal: Goal, subgoal: Subgoal?) {
        let vm = ChecklistAddVM(goal: goal, subgoal: subgoal)
        let vc = ChecklistAddVC(vm: vm)
        vc.coordinator = self
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.custom { _ in vc.modalHeight }]
            sheet.preferredCornerRadius = 0
        }
        
        nav.present(vc, animated: true)
    }
    
}
