//
//  Endpoint.swift
//  Dayme
//
//  Created by 정동천 on 11/19/24.
//

import Foundation

struct Endpoint {
    let method: HttpMethod
    let baseUrl: String
    let path: String
    let params: [String: any Any & Sendable]?
    let headers: [String: String]?
    let intercept: Bool
    
    init(
        method: HttpMethod,
        baseUrl: String,
        path: String,
        params: [String : any Any & Sendable]? = nil,
        headers: [String : String]? = nil,
        intercept: Bool = true
    ) {
        self.method = method
        self.baseUrl = baseUrl
        self.path = path
        self.params = params
        self.headers = headers
        self.intercept = intercept
    }
    
    func withAuthorization(_ token: String) -> Endpoint {
        let authorization = ["Authorization": "Bearer \(token)"]
        return Endpoint(
            method: method,
            baseUrl: baseUrl,
            path: path,
            params: params,
            headers: headers.orEmpty.merging(authorization) { $1 }
        )
    }
}
