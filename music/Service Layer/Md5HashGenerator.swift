//
//  Md5HashGenerator.swift
//  music
//
//  Created by mac-167 on 11/20/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

final class Md5HashGenerator {

    public class func getApiSignatureFor(_ params:[String:String]) -> String? {
        let paramsArray = Array(params.keys).sorted()
        
        let paramsString = paramsArray.flatMap({
            guard let value = params[$0] else { return nil }
            return $0 + value
        }).joined()
        
        let signature = md5(paramsString + SecretKey)
        return signature
    }
    
   private class func md5(_ string: String) -> String {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        return hexString
    }
}
