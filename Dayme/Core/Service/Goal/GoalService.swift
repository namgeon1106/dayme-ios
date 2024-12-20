//
//  GoalService.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import Foundation
import Combine

class GoalService: TokenAccessible {
    
    static let shared = GoalService()
    
    var allGoals: AnyPublisher<[Goal], Never> {
        _allGoals.eraseToAnyPublisher()
    }
    var ongoingGoals: AnyPublisher<[Goal], Never> {
        _ongoingGoals.eraseToAnyPublisher()
    }
    var pastGoals: AnyPublisher<[Goal], Never> {
        _pastGoals.eraseToAnyPublisher()
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    private let _allGoals = CurrentValueSubject<[Goal], Never>([])
    private let _ongoingGoals = CurrentValueSubject<[Goal], Never>([])
    private let _pastGoals = CurrentValueSubject<[Goal], Never>([])
    private let network = Network()
    
    
    private init() {
        bind()
    }
    
    // MARK: - 주요목표
    
    @discardableResult
    func getGoal(id: Int) async throws -> Goal? {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .get,
            baseUrl: Env.serverBaseUrl,
            path: "/goal/\(id)"
        ).withAuthorization(token)
        
        let response: GoalResponse = try await network.request(endpoint)
        let goal = response.toDomain()
        
        if let goal, let index = _allGoals.value.firstIndex(of: goal) {
            var goals = _allGoals.value
            goals[index] = goal
            _allGoals.send(goals)
        }
        
        return goal
    }
    
    
    @discardableResult
    func getGoals() async throws -> [Goal] {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .get,
            baseUrl: Env.serverBaseUrl,
            path: "/goal?status=ALL"
        ).withAuthorization(token)
        
        let json = try await network.request(endpoint)
        let ongoingResponse = try json["IN_PROGRESS"].decode([GoalResponse].self)
        let pastResponse = try json["DONE"].decode([GoalResponse].self)
        
        let goals = (ongoingResponse + pastResponse).compactMap { $0.toDomain() }
        
        _allGoals.send(goals)
        
        return goals
    }
    
    func createGoal(_ goal: Goal) async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .post,
            baseUrl: Env.serverBaseUrl,
            path: "/goal",
            params: AddGoalRequest.fromDomain(goal).toDictionary()
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        // 생성한 id를 현재 모르기 때문에 서버 동기화
        _ = try? await getGoals()
    }
    
    func editGoal(_ goal: Goal) async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .put,
            baseUrl: Env.serverBaseUrl,
            path: "/goal/\(goal.id)",
            params: AddGoalRequest.fromDomain(goal).toDictionary()
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        var goals = _allGoals.value
        if let index = goals.firstIndex(of: goal) {
            goals[index] = goal
            _allGoals.send(goals)
        }
    }
    
    func deleteGoal(_ id: Int) async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .delete,
            baseUrl: Env.serverBaseUrl,
            path: "/goal/\(id)"
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        var goals = _allGoals.value
        if let index = goals.firstIndex(where: { $0.id == id }) {
            goals.remove(at: index)
            _allGoals.send(goals)
        }
    }
    
    // MARK: - 세부목표
    
    func createSubgoal(goalId: Int, _ subgoal: Subgoal) async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .post,
            baseUrl: Env.serverBaseUrl,
            path: "/goal/\(goalId)/subGoal",
            params: AddSubgoalRequest.fromDomain(subgoal).toDictionary()
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        _ = try? await getGoal(id: goalId)
    }
    
    func editSubgoal(goalId: Int, _ subgoal: Subgoal) async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .put,
            baseUrl: Env.serverBaseUrl,
            path: "/goal/subGoal/\(subgoal.id)",
            params: AddSubgoalRequest.fromDomain(subgoal).toDictionary()
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        _ = try? await getGoal(id: goalId)
    }
    
    func deleteSubgoal(goalId: Int, subgoalId: Int) async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .delete,
            baseUrl: Env.serverBaseUrl,
            path: "/goal/subGoal/\(subgoalId)"
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        _ = try? await getGoal(id: goalId)
    }
    
    // MARK: - 체크리스트
    
    func createChecklist(goalId: Int, subgoalId: Int?, _ checklist: Checklist) async throws {
        let subgoalPath = subgoalId.map({ "/\($0)" }).orEmpty
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .post,
            baseUrl: Env.serverBaseUrl,
            path: "/goal/\(goalId)\(subgoalPath)/todo",
            params: AddChecklistRequest.fromDomain(checklist).toDictionary()
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        _ = try? await getGoal(id: goalId)
    }
    
    func editChecklist(goalId: Int, _ checklist: Checklist) async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .put,
            baseUrl: Env.serverBaseUrl,
            path: "/goal/todo/\(checklist.id)",
            params: AddChecklistRequest.fromDomain(checklist).toDictionary()
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        _ = try? await getGoal(id: goalId)
    }
    
    func deleteChecklist(goalId: Int, checklistId: Int) async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .delete,
            baseUrl: Env.serverBaseUrl,
            path: "/goal/todo/\(checklistId)"
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        _ = try? await getGoal(id: goalId)
    }
    
    func toggleChecklistHistory(goalId: Int, historyId: Int) async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .patch,
            baseUrl: Env.serverBaseUrl,
            path: "/goal/todo/\(historyId)/toggle"
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        _ = try? await getGoal(id: goalId)
    }
    
}

extension GoalService {
    
    func refreshGoalsState() {
        _allGoals.send(_allGoals.value)
    }
    
    private func bind() {
        _allGoals.sink { [weak self] goals in
            var ongoingGoals: [Goal] = []
            var pastGoals: [Goal] = []
            let now = Date()
            for goal in goals {
                if now > goal.endDate, !now.isSameDay(with: goal.endDate) {
                    pastGoals.append(goal)
                } else {
                    ongoingGoals.append(goal)
                }
            }
            
            self?._ongoingGoals.send(ongoingGoals)
            self?._pastGoals.send(pastGoals)
        }.store(in: &cancellables)
    }
    
}
