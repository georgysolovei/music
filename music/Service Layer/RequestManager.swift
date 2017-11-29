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
private let ApiMethodGetTopArtists = "chart.getTopArtists"
private let ApiMethodGetArtistTopTracks = "artist.getTopTracks"

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

var isInternetConnection : Bool {
    return networkReachabilityManager?.isReachable ?? false
}

typealias SuccessClosure = (Any) -> Void
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
    
    // MARK: - Generic Request Methods
    @discardableResult
    private class func genericRequest(method: String,
                                  httpMethod: HTTPMethod = .post,
                                      params: [String : Any]? = nil,
                              responseFormat: ResponseFormat = .json,
                                     success: @escaping (_ responseData: Any) -> Void = {_ in },
                                     failure: @escaping FailureClosure = { error in AlertManager.showAlert(title: "Error", message: error)}) -> DataRequest {

        Spinner.shared.startAt()
        
        if responseFormat == .xml {
            return sessionManager.request(ApiBaseUrl, method: httpMethod, parameters: params).responseData(completionHandler: { response in
                
                let handledData = handleGenericResponse(response)
                if let error = handledData.error {
                    failure(error)
                } else {
                    if let data = handledData.data {
                        success(data)
                    } else {
                        failure("No data received")
                    }
                }
                Spinner.shared.stop()
            })
        } else {
            return sessionManager.request(ApiBaseUrl, method: httpMethod, parameters: params).responseJSON(completionHandler: { response in
               
                let handledData = handleGenericResponse(response)
                if let error = handledData.error {
                    failure(error)
                } else {
                    if let data = handledData.data {
                        success(data)
                    } else {
                        failure("No data received")
                    }
                }
                Spinner.shared.stop()
            })
        }
    }

    private class func handleGenericResponse(_ response : Any) -> (error : String?, data : Any?) {
        // Data Response
        if let dataResponse = response as? DataResponse<Data> {
            
            guard dataResponse.result.isSuccess else {
                var errorDescription : String
                let statusCode = dataResponse.response?.statusCode
                errorDescription = checkErrorsFor(statusCode:statusCode)
                
                return (errorDescription, nil)
            }
            
            return (nil, dataResponse)
        
        // JSON Response
        } else if let jsonResponse = response as? DataResponse<Any> {
            guard jsonResponse.result.isSuccess else {
                var errorDescription : String
                let statusCode = jsonResponse.response?.statusCode
                errorDescription = checkErrorsFor(statusCode:statusCode)
                
                return (errorDescription, nil)
            }
            if let result = jsonResponse.result.value {
                let json = JSON(result)

                return (nil, json)
            }
        }
        return("Request failed", nil)
    }
    
    private class func checkErrorsFor(statusCode:Int?) -> String {
        var error = ""
        if !isInternetConnection {
            error = "No Internet conection"
        } else if !isServerConnection {
            error = "Server is unavailable"
        } else if let code = statusCode, ((code == 400) || (500...504 ~= code)) {
            if code == 400 {
                error = "Invalid request"
            } else {
                error = "Service is temporarily unavailable"
            }
        } else {
            error = "Connection failure"
        }
        return error
    }
    
    // MARK: - Requests
    class func getMobileSession(userName:String, password:String, success: @escaping SuccessClosure, failure : @escaping FailureClosure) {
    
        var params = ["api_key": ApiKey,
                       "method": ApiMethodGetMobileSession,
                     "password": password,
                     "username": userName]
        
        params["api_sig"] = Md5HashGenerator.getApiSignatureFor(params)
       
        genericRequest(method: ApiMethodGetMobileSession, params: params, responseFormat: .xml,
                       success: { response in
                        
                        if let responseData = response as? DataResponse<Data> {
                            guard let data = responseData.data else { return }
                            if let sessionKey = XmlParser.getSessionKeyFrom(data) {
                                success(sessionKey)
                            } else {
                                if let error = XmlParser.parseError(data) {
                                    failure(error)
                                }
                            }
                        }
        },
                       failure: failure)
    }
    
    class func getTopArtists(page:Int, success: @escaping ([Artist]) -> Void, failure : @escaping FailureClosure) {
     
        let params = ["method": ApiMethodGetTopArtists,
                     "api_key": ApiKey,
                      "format": "json",
                        "page": page] as [String : Any]
        
        genericRequest(method: ApiMethodGetMobileSession, params: params, responseFormat: .json,
                       success: { response in
                        
                        if let jsonResponse = response as? JSON {
                            let artists = JsonParser.parseArtists(jsonResponse)
                            success(artists)
                        }
        },
                       failure: failure)
    }

    class func getTracksForArtist(_ artist:String, page:Int = 1, success: @escaping ([Track]) -> Void, failure : @escaping FailureClosure) {
        let params = ["method": ApiMethodGetArtistTopTracks,
                      "artist": artist,
                     "api_key": ApiKey,
                      "format": "json",
                        "page": page] as [String : Any]
        
        genericRequest(method: ApiMethodGetMobileSession, params: params, responseFormat: .json,
                       success: { response in
                        
                        if let responseData = response as? JSON {
                            let tracks = JsonParser.parseTracks(responseData)
                            success(tracks)
                        }
        },
                       failure: failure)
    }
}
