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
    private class func genericRequest(method: String,
                                  httpMethod: HTTPMethod = .post,
                                      params: [String : Any]? = nil,
                                     headers: HTTPHeaders? = nil,
                                     success: @escaping (_ responseData: [String : JSON]) -> Void = {_ in },
                                     failure: @escaping FailureClosure = { error in AlertManager.showAlert(title: "Error", message: error)}) -> DataRequest {
      
        let urlString = ApiBaseUrl + method

        return sessionManager.request(urlString, method: .post, parameters: params).responseJSON(completionHandler: { response in
            let handled = handleGenericResponse(response)
            if let error = handled.error {
            
            failure(error)
            return
         }
         
         let data = handled.data ?? [:]
         success(data)
        })
    }
    

     private class func handleGenericResponse(_ response : DataResponse<Any>, responseDataType : Type = .dictionary) -> (error : String?, data : [String : JSON]?)
   {
      guard response.result.isSuccess else
      {
         var errorDescription : String
         
         if !isInternetConnection {
            errorDescription = "No Internet connection"
         }
         else if !isServerConnection {
            errorDescription = "Server is unavailable"
         }
         else if let code = response.response?.statusCode, ((code == 400) || (500...504 ~= code))
         {
            if code == 400 {
               errorDescription = "Invalid request"
            }
            else {
               errorDescription = "Service is unavailable"
            }
         }
         else if let localizedDescription = response.result.error?.localizedDescription {
            errorDescription = localizedDescription
         }
         else {
            errorDescription = "Connection failure"
         }
         
         return (errorDescription, nil)
      }
      
      guard let value = response.result.value else {
         return ("No data", nil)
      }
      let json = JSON(value)
      
      if json.type != .dictionary {
         return ("No data", nil)
      }
    
      let status = json["status"].stringValue
      if status != "SUCCESS"
      {
         let errorDescription = json["errorMessage"].stringValue
         return (errorDescription, nil)
      }
      
      if responseDataType == .null {
         return (nil, [:])
      }
      
      let responseData = json["response"]
      let type = responseData.type

      if type != responseDataType {
         return ("No data", nil)
      }
      
      switch type
      {
         case .dictionary: return (nil, responseData.dictionary)
         case .null, .unknown : return (nil, [:])
         default : return (nil, ["value" : responseData])
      }
   }
    class func getMobileSession(success: @escaping SuccessClosure) {
        
        
    }
}

