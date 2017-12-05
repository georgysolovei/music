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
        Spinner.shared.startAt()
        
        var params:[String: String] = ["api_key": ApiKey,
                                        "method": ApiMethodGetMobileSession,
                                      "password": password,
                                      "username": userName]
        
        params["api_sig"] = Md5HashGenerator.getApiSignatureFor(params)
        
        return sessionManager.rx.data(.post, ApiBaseUrl, parameters: params)
            .map({ data -> String? in
                Spinner.shared.stop()
                return XmlParser.getSessionKeyFrom(data)
        })
    }
    
    class func getTopArtists(page:Int) -> Observable<[Artist]?> {
        Spinner.shared.startAt()

        let params = ["method": ApiMethodGetTopArtists,
                     "api_key": ApiKey,
                      "format": "json",
                        "page": page] as [String : Any]
        
        return sessionManager.rx.json(.post, ApiBaseUrl, parameters: params)
            .map({ jsonArtists -> [Artist]? in
                let artists = JSON(jsonArtists)
                Spinner.shared.stop()
                return JsonParser.parseArtists(artists)
            })
    }

    class func getTracksForArtist(_ artist:String, page:Int = 1) -> Observable<[Track]?> {
        Spinner.shared.startAt()

        let params = ["method": ApiMethodGetArtistTopTracks,
                      "artist": artist,
                     "api_key": ApiKey,
                      "format": "json",
                        "page": page] as [String : Any]
        
        return sessionManager.rx.json(.post, ApiBaseUrl, parameters: params)
            .map({ rawTracks in
                let jsonTracks = JSON(rawTracks)
                Spinner.shared.stop()
                return JsonParser.parseTracks(jsonTracks)
            })
    }
}
