//
//  NetworkLogger.swift
//  Dayme
//
//  Created by 정동천 on 11/6/24.
//

import Foundation
import Alamofire

final class NetworkLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "NetworkLogger")
    
    func requestDidFinish(_ request: Request) {
        guard let urlRequest = request.request else { return }
        
        Logger.network {
            """
            REQUEST FINISHED 🟢
            [\(urlRequest.httpMethod ?? "")] \(urlRequest.url?.absoluteString ?? "")
            """
        }
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        guard let urlRequest = request.request else { return }
        
        Logger.network {
            """
            RESPONSE RECEIVED 🟢
            [\(urlRequest.httpMethod ?? "")] \(urlRequest.url?.absoluteString ?? "")
            Status Code: \(response.response?.statusCode ?? -1)
            Headers: \(response.response?.allHeaderFields ?? [:])
            Data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No Response Data")
            """
        }
    }
    
    func request(_ request: Request, didFailTask task: URLSessionTask, earlyWithError error: AFError) {
        Logger.network {
            """
            REQUEST FAILED 🔴
            Error: \(error.localizedDescription)
            """
        }
    }
    
    func request(_ request: Request, didFailToCreateURLRequestWithError error: AFError) {
        Logger.network {
            """
            FAILED TO CREATE URL REQUEST 🔴
            Error: \(error.localizedDescription)
            """
        }
    }
    
}
