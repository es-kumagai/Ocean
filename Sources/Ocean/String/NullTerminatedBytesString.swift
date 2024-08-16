//
//  NullTerminatedBytesString.swift
//
//
//  Created by Tomohiro Kumagai on 2024/07/27.
//

import Foundation

public extension String {
    
    init?(nullTerminatedBytes bytes: some Collection<UInt8>, encoding: String.Encoding) {
        
        switch bytes.firstIndex(of: 0) {
            
        case let terminatorIndex?:
            self.init(bytes: bytes[bytes.startIndex ..< terminatorIndex], encoding: encoding)

        case nil:
            self.init(bytes: bytes, encoding: encoding)
        }
    }
}
