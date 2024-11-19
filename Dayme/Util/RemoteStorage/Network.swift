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
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let response = await dataRequest(endpoint)
            .serializingDecodable(T.self, decoder: decoder)
            .response
        
        guard let statusCode = response.response?.statusCode else {
            throw response.error ?? ServerError(errorCode: .unknown, message: "응답이 없습니다.")
        }
        
        if !((200 ..< 300) ~= statusCode), let data = response.data {
            throw try decoder.decode(ServerError.self, from: data)
        }
        
        return try response.result.get()
    }
    
    func request(_ endpoint: Endpoint) async throws {
        let response = await dataRequest(endpoint)
            .serializingData()
            .response
        
        guard let statusCode = response.response?.statusCode else {
            throw response.error ?? ServerError(errorCode: .unknown, message: "응답이 없습니다.")
        }
        
        if !((200 ..< 300) ~= statusCode), let data = response.data {
            throw try decoder.decode(ServerError.self, from: data)
        }
    }
    
    // MARK: - 네트워크 설정
    
    private let session: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        let logger = NetworkLogger()
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
    
    func dataRequest(_ endpoint: Endpoint) -> DataRequest {
        let header = defaultHeader.merging(endpoint.headers.orEmpty) { $1 }
        
        return session.request(
            endpoint.baseUrl + endpoint.path,
            method: endpoint.method.af,
            parameters: endpoint.params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(header)
        )
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
