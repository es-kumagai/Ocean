//
//  Byte.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/05/05
//  
//

import Foundation
import Swim

public extension Bytes {
    
    init(_ data: borrowing Data) {
        self = data.map { Byte($0) }
    }
}

public extension Data {
    
    init(_ bytes: borrowing Bytes) {
        
        self = bytes.withUnsafeBytes { bytes in
            Data(bytes: bytes.baseAddress!, count: bytes.count)
        }
    }
    
    init(_ bytes: consuming some Sequence<Byte>) {
        self.init(Bytes(bytes))
    }
}
