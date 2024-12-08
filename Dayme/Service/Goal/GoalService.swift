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
    
}
