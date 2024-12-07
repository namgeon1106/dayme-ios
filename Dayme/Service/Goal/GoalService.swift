//
//  GoalService.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import Foundation

class GoalService: TokenAccessible {
    
    private let network = Network()
    
    @MainActor
    func getGoals() async throws -> [Goal] {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .get,
            baseUrl: Env.serverBaseUrl,
            path: "/goal"
        ).withAuthorization(token)
        
        let reponse: [GoalResponse] = try await network.request(endpoint)
        
        return reponse.compactMap { $0.toDomain() }
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
    }
    
}
