//
//  RandomData.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/01/30.
//

import Foundation

extension Data {
    
    /// [Ocean] Generate a random byte data.
    /// - Parameter count: length of generating data.
    public static func randomBytes(count: Int) -> Data {
        
        let randomIterator = AnyIterator<UInt8> {
            
            return (0 ... 255).randomElement()
        }
        
        return Data(randomIterator.prefix(count))
    }
}
