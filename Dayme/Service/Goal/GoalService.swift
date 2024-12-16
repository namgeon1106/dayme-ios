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
    
    var goals: AnyPublisher<[Goal], Never> {
        _goals.eraseToAnyPublisher()
    }
    
    private let _goals = CurrentValueSubject<[Goal], Never>([])
    private let network = Network()
    
    
    private init() {}
    
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
        
        if let goal, let index = _goals.value.firstIndex(of: goal) {
            var goals = _goals.value
            goals[index] = goal
            _goals.send(goals)
        }
        
        return goal
    }
    
    
    @discardableResult
    func getGoals() async throws -> [Goal] {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .get,
            baseUrl: Env.serverBaseUrl,
            path: "/goal"
        ).withAuthorization(token)
        
        let reponse: [GoalResponse] = try await network.request(endpoint)
        let goals = reponse.compactMap { $0.toDomain() }
        _goals.send(goals)
        
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
        
        var goals = _goals.value
        if let index = goals.firstIndex(of: goal) {
            goals[index] = goal
            _goals.send(goals)
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
        
        var goals = _goals.value
        if let index = goals.firstIndex(where: { $0.id == id }) {
            goals.remove(at: index)
            _goals.send(goals)
        }
    }
    
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
    
}
