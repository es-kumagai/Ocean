//
//  File.swift
//  
//
//  Created by Tomohiro Kumagai on 2021/06/20.
//

import Foundation

public extension String {
    
    /// [Ocean] Creates a instance from a CFString instance.
    /// - Parameter ref: The string as CFString type.
    init(cfStringRef ref: UnsafeRawPointer!) {
    
        self = unsafeBitCast(ref, to: CFString.self) as String
    }
}
