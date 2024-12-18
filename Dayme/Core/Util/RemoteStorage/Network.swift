//
//  Network.swift
//  Dayme
//
//  Created by 정동천 on 11/6/24.
//

import Foundation
import Alamofire

enum HttpMethod: String {
    case get, delete, post, put, patch
    
    var code: String { rawValue.uppercased() }
}

final class Network {
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let response = await dataRequest(endpoint)
            .serializingDecodable(T.self, decoder: decoder)
            .response
        
        guard let statusCode = response.response?.statusCode, let data = response.data else {
            throw response.error ?? ServerError(errorCode: .unknown, message: "응답이 없습니다.")
        }
        
        let isValid: Bool = (200 ..< 300) ~= statusCode
        
        Logger.debug {
            """
            NETWORK RESPONSE \(isValid ? "🟢" : "🔴")
            [\(endpoint.method.code)/\(statusCode)] \(endpoint.baseUrl)\(endpoint.path)
            \(data.prettyString.orEmpty)
            """
        }
        
        if !isValid {
            throw try decoder.decode(ServerError.self, from: data)
        }
        
        return try response.result.get()
    }
    
    @discardableResult
    func request(_ endpoint: Endpoint) async throws -> JSON {
        let response = await dataRequest(endpoint)
            .serializingData()
            .response
        
        guard let statusCode = response.response?.statusCode, let data = response.data else {
            throw response.error ?? ServerError(errorCode: .unknown, message: "응답이 없습니다.")
        }
        
        let isValid: Bool = (200 ..< 300) ~= statusCode
        
        Logger.debug {
            """
            NETWORK RESPONSE \(isValid ? "🟢" : "🔴")
            [\(endpoint.method.code)/\(statusCode)] \(endpoint.baseUrl)\(endpoint.path)
            \(data.prettyString.orEmpty)
            """
        }
        
        if !isValid {
            throw try decoder.decode(ServerError.self, from: data)
        }
        
        return JSON(data)
    }
    
    // MARK: - 네트워크 설정
    
    private let logger = NetworkLogger()
    
    private lazy var session: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        return Session(configuration: config, eventMonitors: [logger])
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let defaultHeader: [String: String] = [
        "Accept": "*/*",
        "Accept-Encoding": "gzip, defalte, br",
        "Content-Type": "application/json",
        "Connection": "keep-alive"
    ]
    
}

private extension Network {
    
    func dataRequest(_ endpoint: Endpoint) async -> DataRequest {
        let header = defaultHeader.merging(endpoint.headers.orEmpty) { $1 }
        
        // Session 초기화가 I/O 관련이 있어 background 초기화
        let session = await Task(priority: .background) {
            return self.session
        }.value
        
        let interceptor = endpoint.intercept ? NetworkInterceptor() : nil
        
        return session.request(
            endpoint.baseUrl + endpoint.path,
            method: endpoint.method.af,
            parameters: endpoint.params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(header),
            interceptor: interceptor
        )
    }
    
}

fileprivate extension HttpMethod {
    var af: Alamofire.HTTPMethod { .init(rawValue: rawValue) }
}
