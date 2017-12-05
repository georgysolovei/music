//
//  RequestManager.swift
//  music
//
//  Created by mac-167 on 11/17/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import SwiftyJSON
import Alamofire
import RxAlamofire
import RxSwift

private let ApiBaseUrl = "https://ws.audioscrobbler.com/2.0/"
private let ApiMethodGetMobileSession = "auth.getMobileSession"
private let ApiMethodGetTopArtists = "chart.getTopArtists"
private let ApiMethodGetArtistTopTracks = "artist.getTopTracks"

final class RequestManager {
    
    static var sessionManager : SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = SessionManager(configuration: configuration)
        return manager
    }()
    
// MARK: - Requests
//--------------------------------------------------------------------------------------------
    class func getMobileSession(userName:String, password:String) -> Observable<String?> {

        var params:[String: String] = ["api_key": ApiKey,
                                        "method": ApiMethodGetMobileSession,
                                      "password": password,
                                      "username": userName]
        
        params["api_sig"] = Md5HashGenerator.getApiSignatureFor(params)
        
        return sessionManager.rx.data(.post, ApiBaseUrl, parameters: params)
            .map({ data -> String? in
                return XmlParser.getSessionKeyFrom(data)
        })
    }
    
    class func getTopArtists(page:Int) -> Observable<[Artist]?> {
    
        let params = ["method": ApiMethodGetTopArtists,
                     "api_key": ApiKey,
                      "format": "json",
                        "page": page] as [String : Any]
        
        return sessionManager.rx.json(.post, ApiBaseUrl, parameters: params)
            .map({ jsonArtists -> [Artist]? in
                let artists = JSON(jsonArtists)
                return JsonParser.parseArtists(artists)
            })
    }

    class func getTracksForArtist(_ artist:String, page:Int = 1) -> Observable<[Track]?> {
    
        let params = ["method": ApiMethodGetArtistTopTracks,
                      "artist": artist,
                     "api_key": ApiKey,
                      "format": "json",
                        "page": page] as [String : Any]
        
        return sessionManager.rx.json(.post, ApiBaseUrl, parameters: params)
            .map({ jsonTracks in
                guard let tracks = jsonTracks as? JSON else { return nil }
                return JsonParser.parseTracks(tracks)
            })
    }
}

//    enum ResponseFormat {
//        case json
//        case xml
//    }
//

//
//    // MARK: - Generic Request Methods
//    @discardableResult
//    private class func genericRequest(httpMethod: HTTPMethod = .post,
//                                      params: [String : Any]? = nil,
//                                      responseFormat: ResponseFormat = .json,
//                                      success: @escaping (_ responseData: Any) -> Void = {_ in },
//                                      failure: @escaping FailureClosure = { error in AlertManager.showAlert(title: "Error", message: error)}) -> DataRequest {
//        Spinner.shared.startAt()
//
//        if responseFormat == .xml {
//            return sessionManager.request(ApiBaseUrl, method: httpMethod, parameters: params).responseData(completionHandler: { response in
//
//                let handledData = handleGenericResponse(response)
//                if let error = handledData.error {
//                    failure(error)
//                } else {
//                    if let data = handledData.data {
//                        success(data)
//                    } else {
//                        failure("No data received")
//                    }
//                }
//                Spinner.shared.stop()
//            })
//        } else {
//            return sessionManager.request(ApiBaseUrl, method: httpMethod, parameters: params).responseJSON(completionHandler: { response in
//
//                let handledData = handleGenericResponse(response)
//                if let error = handledData.error {
//                    failure(error)
//                } else {
//                    if let data = handledData.data {
//                        success(data)
//                    } else {
//                        failure("No data received")
//                    }
//                }
//                Spinner.shared.stop()
//            })
//        }
//    }
//
//    private class func handleGenericResponse(_ response : Any) -> (error : String?, data : Any?) {
//        // Data Response
//        if let dataResponse = response as? DataResponse<Data> {
//
//            guard dataResponse.result.isSuccess else {
//                var errorDescription : String
//                let statusCode = dataResponse.response?.statusCode
//                errorDescription = checkErrorsFor(statusCode:statusCode)
//
//                return (errorDescription, nil)
//            }
//
//            return (nil, dataResponse)
//
//            // JSON Response
//        } else if let jsonResponse = response as? DataResponse<Any> {
//            guard jsonResponse.result.isSuccess else {
//                var errorDescription : String
//                let statusCode = jsonResponse.response?.statusCode
//                errorDescription = checkErrorsFor(statusCode:statusCode)
//
//                return (errorDescription, nil)
//            }
//            if let result = jsonResponse.result.value {
//                let json = JSON(result)
//
//                return (nil, json)
//            }
//        }
//        return("Request failed", nil)
//    }
//
//    private class func checkErrorsFor(statusCode:Int?) -> String {
//        var error = ""
//        if !isInternetConnection {
//            error = "No Internet conection"
//        } else if !isServerConnection {
//            error = "Server is unavailable"
//        } else if let code = statusCode, ((code == 400) || (500...504 ~= code)) {
//            if code == 400 {
//                error = "Invalid request"
//            } else {
//                error = "Service is temporarily unavailable"
//            }
//        } else {
//            error = "Connection failure"
//        }
//        return error
//    }


// Reachability
//let serverReachabilityManager: NetworkReachabilityManager? = {
//    let manager = NetworkReachabilityManager(host: ApiBaseUrl)
//    manager?.startListening()
//    return manager
//}()
//
//let networkReachabilityManager: NetworkReachabilityManager? = {
//    let manager = NetworkReachabilityManager()
//    manager?.startListening()
//    return manager
//}()
//
//var isServerConnection : Bool {
//    return serverReachabilityManager?.isReachable ?? false
//}
//
//var isInternetConnection : Bool {
//    return networkReachabilityManager?.isReachable ?? false
//}
//
//typealias SuccessClosure = (Any) -> Void
//typealias FailureClosure = (_ errorDescription : String) -> Void

