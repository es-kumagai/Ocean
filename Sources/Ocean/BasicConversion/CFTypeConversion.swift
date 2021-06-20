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

public extension Bool {
    
    /// [Ocean] Creates a instance from a CFBoolean instance.
    /// - Parameter ref: The value as CFBoolean type.
    init(cfBooleanRef ref: UnsafeRawPointer!) {
        
        self = CFBooleanGetValue(unsafeBitCast(ref, to: CFBoolean.self))
    }
}

public extension Array {
    
    init(cfArrayRef ref: UnsafeRawPointer!) {
        
        /// [Ocean] Creates a instance from a CFArray instance.
        /// - Parameter ref: The value as CFArray type.
        self = unsafeBitCast(ref, to: CFArray.self) as! Self
    }
}
