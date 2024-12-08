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
    
    
    @MainActor
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
    
    @MainActor
    func createGoal(_ goal: Goal) async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .post,
            baseUrl: Env.serverBaseUrl,
            path: "/goal",
            params: AddGoalRequest.fromDomain(goal).toDictionary()
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        _goals.send(_goals.value + [goal])
    }
    
}
