//
//  Network.swift
//  Dayme
//
//  Created by 정동천 on 11/6/24.
//

import Foundation
import Alamofire

enum HttpMethod {
    case get, delete, post
}

final class Network {
    
    private let session: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        let logger = NetworkLogger()
        return Session(configuration: config, eventMonitors: [logger])
    }()
    
    func request<T: Decodable>(
        _ method: HttpMethod,
        baseUrl: String,
        path: String,
        params: [String: any Any & Sendable]? = nil,
        headers: [String: String]? = nil
    ) async throws -> T {
        return try await session.request(
            baseUrl + path,
            method: .get,
            parameters: params,
            headers: headers.map(HTTPHeaders.init)
        )
        .serializingDecodable()
        .value
    }
    
}

fileprivate extension HttpMethod {
    var af: Alamofire.HTTPMethod {
        switch self {
        case .get: .get
        case .delete: .delete
        case .post: .post
        }
    }
}
