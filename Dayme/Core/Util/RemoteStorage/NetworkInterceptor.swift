//
//  NetworkInterceptor.swift
//  Dayme
//
//  Created by 정동천 on 12/14/24.
//

import Foundation
import Alamofire

final class NetworkInterceptor: RequestInterceptor {
    
    private let retryLimit: Int = 1
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let token = Keychain.read(key: Env.Keychain.accessTokenKey) {
            request.headers.add(name: "Authorization", value: "Bearer \(token)")
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        Logger.error(error)
        
        guard request.retryCount < retryLimit, let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // Refresh Token
        if response.statusCode == 401 {
            Task {
                do {
                    try await AuthService().refreshToken()
                    completion(.retry)
                } catch {
                    completion(.doNotRetry)
                }
            }
        }
    }
}
