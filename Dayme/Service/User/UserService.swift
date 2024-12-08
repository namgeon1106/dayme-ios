//
//  UserService.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import Foundation
import Combine

class UserService: TokenAccessible {
    
    static let shared = UserService()
    
    var user: AnyPublisher<User?, Never> {
        _user.eraseToAnyPublisher()
    }
    
    private let _user = CurrentValueSubject<User?, Never>(nil)
    private let network = Network()
    
    
    private init() {}
    
    
    @MainActor
    @discardableResult
    func getUser() async throws -> User {
        let token = try getAccessToken()
        let endpoint = Endpoint(
            method: .get,
            baseUrl: Env.serverBaseUrl,
            path: "/member"
        ).withAuthorization(token)
        
        let reponse: UserResponse = try await network.request(endpoint)
        let user = reponse.toDomain()
        _user.send(user)
        
        return user
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
        
        _user.send(nil)
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
