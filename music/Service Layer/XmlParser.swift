//
//  XmlParser.swift
//  music
//
//  Created by mac-167 on 11/20/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import KissXML

final class XmlParser {    
    public class func getSessionKeyFrom(_ receivedData:Data) -> String? {

        if let document = try? DDXMLDocument.init(data: receivedData, options: 0) {
            if let sessionKey = try? document.nodes(forXPath: "//key") {
                return sessionKey.first?.stringValue
            }
        }
        return nil
    }
    
    public class func parseError(_ receivedData:Data) -> String? {
        if let document = try? DDXMLDocument.init(data: receivedData, options: 0) {
            if let sessionKey = try? document.nodes(forXPath: "//error") {
                return sessionKey.first?.stringValue
            }
        }
        return nil
    }
}
