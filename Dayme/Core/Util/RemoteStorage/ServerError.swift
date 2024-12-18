//
//  ServerError.swift
//  Dayme
//
//  Created by 정동천 on 11/19/24.
//

import Foundation

struct ServerError: Decodable, LocalizedError {
    let errorCode: ServerErrorCode
    let message: String
    
    var errorDescription: String? { message }
    
    enum CodingKeys: CodingKey {
        case errorCode
        case message
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let errorCodeString = try container.decode(String.self, forKey: .errorCode)
        self.errorCode = ServerErrorCode(rawValue: errorCodeString) ?? .unknown
        self.message = try container.decode(String.self, forKey: .message)
    }
    
    init(errorCode: ServerErrorCode, message: String) {
        self.errorCode = errorCode
        self.message = message
    }
}

enum ServerErrorCode: String {
    case memberIdentityNotFound = "EXCEPTION:MEMBER_IDENTITY_NOT_FOUND"
    case accessDenied = "EXCEPTION:ACCESS_DENIED"
    case internalServerError = "EXCEPTION:INTERNAL_SERVER_ERROR"
    case notAuthorized = "EXCEPTION:NOT_AUTHORIZED"
    case unknown
}
