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
        
        print("URL: \(request.request?.url?.absoluteString ?? "")")
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        //
    }
    
    func request(_ request: Request, didFailTask task: URLSessionTask, earlyWithError error: AFError) {
        //
    }
    
    func request(_ request: Request, didFailToCreateURLRequestWithError error: AFError) {
        //
    }
    
}
