//
//  CError.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/12/10.
//

import Foundation

/// [Ocean] An error expressed by C language style.
public struct CError {
    
    public var code: Int32
    
    /// [Ocean] Create a new instance with C style error code.
    /// - Parameter code: An error code that expressed by C style.
    public init(_ code: Int32) {
        
        self.code = code
    }
    
    /// [Ocean] Create a new instance with global error code in `errno`.
    public init() {
        
        self.init(errno)
    }
}

extension CError : CustomStringConvertible {
    
    /// [Ocean] The description of the global error code in `errno`.
    public static var description: String {
    
        return Self().description
    }
    
    /// [Ocean] The description of this value.
    public var description: String {
        
        return String(cString: strerror(code))
    }
}

extension CError : Equatable {
    
}
