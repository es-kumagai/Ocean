//
//  RandomString.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/01/30.
//

import Foundation

extension Cryption.AES {
    
    public static func generateRandomInitialVectorString() -> String {
    
        return String.randomPrintableString(count: initialVectorSize)
    }
    
    public static func generateRandomSharedKeyString() -> String {
        
        return String.randomPrintableString(count: sharedKeySize)
    }
    
    public static func generateRandomInitialVectorData() -> Data {
    
        return Data.randomBytes(count: initialVectorSize)
    }
    
    public static func generateRandomSharedKeyData() -> Data {
        
        return Data.randomBytes(count: sharedKeySize)
    }
}
