//
//  UserService.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import Foundation

class UserService: TokenAccessible {
    
    private let network = Network()
    
    @MainActor
    func getUser() async throws -> User {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .get,
            baseUrl: Env.serverBaseUrl,
            path: "/member"
        ).withAuthorization(token)
        
        let reponse: UserResponse = try await network.request(endpoint)
        
        return reponse.toDomain()
    }
    
    @MainActor
    func deleteUser() async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .delete,
            baseUrl: Env.serverBaseUrl,
            path: "/member"
        ).withAuthorization(token)
        
        try await network.request(endpoint)
        
        removeToken()
        UserDefault.loggedIn = false
        UserDefault.socialLogin = nil
    }
    
    @MainActor
    func resetPassword(_ password: String) async throws {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .patch,
            baseUrl: Env.serverBaseUrl,
            path: "/member/password"
        ).withAuthorization(token)
        
        try await network.request(endpoint)
    }
    
}
