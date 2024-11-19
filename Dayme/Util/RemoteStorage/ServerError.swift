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
    case invalidCredentials = "EXCEPTION:INVALID_CREDENTIALS"
    case accessDenied = "EXCEPTION:ACCESS_DENIED"
    case internalServerError = "EXCEPTION:INTERNAL_SERVER_ERROR"
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .memberIdentityNotFound:
            "회원 정보를 찾을 수 없습니다."
        case .invalidCredentials:
            "잘못된 자격 증명입니다. 다시 시도해주세요."
        case .accessDenied:
            "접근이 거부되었습니다."
        case .internalServerError:
            "서버 내부 오류가 발생했습니다."
        case .unknown:
            "알 수 없는 오류가 발생했습니다."
        }
    }
}
