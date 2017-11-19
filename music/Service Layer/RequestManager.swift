//
//  RequestManager.swift
//  music
//
//  Created by mac-167 on 11/17/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import Foundation
import Alamofire

final class RequestManager {
    static let baseUrl = "https://ws.audioscrobbler.com/2.0/"
    static let apiGetMobileSession = "auth.getMobileSession"
    
    typealias successClosure = (Any) -> Void
    
    static let sessionMananger: SessionManager = {
        
        let sessionManager = SessionManager.default
        return sessionManager
    }()
    
    class func genericRequest(params:[String:Any], success: @escaping successClosure) {
        
        sessionMananger.request(baseUrl,
                                method: .post,
                                parameters: params,
                                encoding: URLEncoding.default)
            .validate().response(completionHandler: { response in
                
                
            })
    }
    
    class func getMobileSession(success: @escaping successClosure) {
        
        let params = ["" : ""]
        
        genericRequest(params: params, success: {response in
            
            success(response)
            
        })
    }
}

