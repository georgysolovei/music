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
    
    enum ResponseFormat {
        case json
        case xml
    }
    
    static var sessionManager : SessionManager =
    {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        let manager = SessionManager(configuration: configuration)
        
        return manager
    }()
    
    // MARK: - Generic Request
    @discardableResult
    private class func genericRequest(method: String,
                                  httpMethod: HTTPMethod = .post,
                                      params: [String : Any]? = nil,
                              responseFormat: ResponseFormat = .json,
                                     success: @escaping (_ responseData: Any) -> Void = {_ in },
                                     failure: @escaping FailureClosure = { error in AlertManager.showAlert(title: "Error", message: error)}) -> DataRequest {

        if responseFormat == .xml {
            return sessionManager.request(ApiBaseUrl, method: .post, parameters: params).responseData(completionHandler: { response in
                
                 print(String.init(data: response.data!, encoding: String.Encoding.utf8))
                
                if let responseData = response.data {
                    
                    let parser = XmlParser()
                    parser.getSessionKeyFrom(responseData)
                    
                    success(responseData)
                } else {
                    print("WRONG RESPONSE")
                }
            })
        } else {
            return sessionManager.request(ApiBaseUrl, method: .post, parameters: params).responseJSON(completionHandler: { response in
                print(response)
            })
        }
    }
    
    // MARK: - Requests
    class func getMobileSession(userName:String, password:String, success: @escaping SuccessClosure, failure : @escaping FailureClosure) {
        var params = ["api_key": ApiKey,
                       "method": ApiMethodGetMobileSession,
                     "password": password,
                     "username": userName]
        
        params["api_sig"] = Md5HashGenerator.getApiSignatureFor(params)
       
        genericRequest(method: ApiMethodGetMobileSession, params: params, responseFormat: .xml,
                       success: { responseData in
                        print(responseData)
                        if responseData is Data {

                            
                        }
        },
                       failure: failure)
    }
}

