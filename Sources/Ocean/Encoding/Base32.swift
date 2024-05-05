//
//  Base32.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/05/05
//  
//

import Foundation
import Swim

public extension Base32 {
    
    static func encoding(_ data: Data) -> Data {
        
        let bytes = Bytes(data)
        let encodedBytes = encoding(bytes)
        
        return Data(encodedBytes)
    }
}

public extension Data {
    
    init?(base32Encoded data: Data) {
        
        guard let encodedText = String(data: data, encoding: .ascii) else {
            return nil
        }
        
        guard let decodedBytes = Base32.decoding(encodedText) else {
            return nil
        }
        
        self.init(decodedBytes)
    }
    
    func base32EncodedString() -> String {
     
        let encodedBytes = Base32.encoding(self)
        let encodedData = Data(encodedBytes)
        
        return String(data: encodedData, encoding: .ascii)!
    }
}
