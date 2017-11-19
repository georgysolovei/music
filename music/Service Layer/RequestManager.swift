//
//  RequestManager.swift
//  music
//
//  Created by mac-167 on 11/17/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private let ApiBaseUrl = "https://ws.audioscrobbler.com/2.0/"
private let ApiMethodGetMobileSession = "auth.getMobileSession"

// Reachability
let serverReachabilityManager: NetworkReachabilityManager? = {
    let manager = NetworkReachabilityManager(host: ApiBaseUrl)
    manager?.startListening()
    return manager
}()
let networkReachabilityManager: NetworkReachabilityManager? = {
    let manager = NetworkReachabilityManager()
    manager?.startListening()
    return manager
}()

var isServerConnection : Bool {
    return serverReachabilityManager?.isReachable ?? false
}
var isServerWiFiConnection : Bool {
    return serverReachabilityManager?.isReachableOnEthernetOrWiFi ?? false
}
var isInternetConnection : Bool {
    return networkReachabilityManager?.isReachable ?? false
}
var isInternetWiFiConnection : Bool {
    return networkReachabilityManager?.isReachableOnEthernetOrWiFi ?? false
}

typealias SuccessClosure = () -> Void
typealias FailureClosure = (_ errorDescription : String) -> Void


final class RequestManager {
    
    static var sessionManager : SessionManager =
    {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        let manager = SessionManager(configuration: configuration)
        
        return manager
    }()
    
    class func startReachability() {
        _ = serverReachabilityManager
        _ = networkReachabilityManager
    }
    
    @discardableResult
    private class func genericRequest(method : String,
                                      httpMethod : HTTPMethod = .post,
                                      params : [String : Any]? = nil,
                                      headers: HTTPHeaders? = nil,
                                      success: @escaping (_ responseData: [String : JSON]) -> Void = {_ in },
                                      failure: @escaping FailureClosure = { error in AlertManager.showAlert(title: "Ошибка", message: error)}) -> DataRequest {
        let urlString = ApiBaseUrl + method

        return sessionManager.request(urlString, method: .post, parameters: params)
    }
    

    
    class func getMobileSession(success: @escaping SuccessClosure) {
        
        
    }
}

