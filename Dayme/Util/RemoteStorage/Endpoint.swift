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
    
    init(
        method: HttpMethod,
        baseUrl: String,
        path: String,
        params: [String : any Any & Sendable]? = nil,
        headers: [String : String]? = nil
    ) {
        self.method = method
        self.baseUrl = baseUrl
        self.path = path
        self.params = params
        self.headers = headers
    }
}
