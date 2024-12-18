//
//  DeviceManager.swift
//  Dayme
//
//  Created by 정동천 on 12/18/24.
//

import Foundation

final class DeviceManager {
    
    static let shared = DeviceManager()
    
    private let network = Network()
    
    
    private init() {}
    
    
    func checkVersion() async throws -> Bool {
        let endpoint = Endpoint(
            method: .get,
            baseUrl: Env.serverBaseUrl,
            path: "/app/version/ios"
        )
        
        let json = try await network.request(endpoint)
        let minimumVersion = json["version"].string.orEmpty
        let currentVersion = Env.appVersion
        
        Logger.debug {
            """
            CurrentVersion: \(currentVersion)
            MinimumVersion: \(minimumVersion)
            """
        }
        
        return currentVersion.compare(minimumVersion, options: .numeric) != .orderedAscending
    }
    
}
