//
//  JsonParser.swift
//  music
//
//  Created by mac-167 on 11/21/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import Foundation
import SwiftyJSON

final class JsonParser {
    class func parseArtists(_ json:JSON) -> [Artist] {
        
        var artists = [Artist]()

        guard let jsonArtistsDictionary = json.dictionary              else { return artists }
        guard let artistsDictionary = jsonArtistsDictionary["artists"] else { return artists }
        guard let jsonArtistArray = artistsDictionary["artist"].array  else { return artists }


        for jsonArtist in jsonArtistArray {
            let artist = Artist()
            
            artist.name      = jsonArtist.dictionaryValue["name"]?.stringValue ?? ""
            artist.listeners = jsonArtist.dictionaryValue["listeners"]?.stringValue ?? ""
            artist.url       = jsonArtist.dictionaryValue["url"]?.stringValue ?? ""
            
            guard let imageUrls = jsonArtist.dictionaryValue["image"]?.array else { continue }
         
            for imageUrl in imageUrls {
                guard let imageDict = imageUrl.dictionary else { continue }

                if imageDict["size"] == "extralarge" {
                    artist.imageUrl  = imageDict["#text"]?.stringValue ?? ""
                }
            }
            artists.append(artist)
        }
        return artists
    }
    
    class func parseTracks(_ json:JSON) -> [Track] {
       
        var tracks = [Track]()

        guard let jsonTracksDictionary = json.dictionary               else { return tracks }
        guard let tracksDictionary = jsonTracksDictionary["toptracks"] else { return tracks }
        guard let jsonTracksArray = tracksDictionary["track"].array    else { return tracks }
        
        for jsonTrack in jsonTracksArray {
            let track = Track()
            
            track.name      = jsonTrack.dictionaryValue["name"]?.stringValue ?? ""
            track.listeners = jsonTrack.dictionaryValue["listeners"]?.stringValue ?? ""
            track.playcount = jsonTrack.dictionaryValue["playcount"]?.stringValue ?? ""
            track.rank      = jsonTrack.dictionaryValue["@attr"]?.dictionaryValue["rank"]?.stringValue ?? ""
            
            guard let imageUrls = jsonTrack.dictionaryValue["image"]?.array else { continue }
            
            for imageUrl in imageUrls {
                guard let imageDict = imageUrl.dictionary else { continue }
                
                if imageDict["size"] == "extralarge" {
                    track.imageUrl  = imageDict["#text"]?.stringValue ?? ""
                }
            }
            tracks.append(track)
        }
        return tracks
    }
}
