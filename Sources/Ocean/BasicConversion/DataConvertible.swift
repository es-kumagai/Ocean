//
//  DataConvertible.swift
//  FoundationEnhancement
//
//  Created by Tomohiro Kumagai on 2021/02/14.
//

import Foundation

/// [Ocean] A type that can convert to `Data` type.
public protocol DataConvertible {
    
    /// [Ocean] A data that is converted from this instance.
    var data: Data { get }
}

extension Data : DataConvertible {

    public var data: Data {
        
        return self
    }
}

extension Optional : DataConvertible where Wrapped : DataConvertible {
    
    public var data: Data {
        
        switch self {
        
        case .some(let value):
            return value.data
            
        case .none:
            return Data()
        }
    }
}

extension Collection where Element : DataConvertible {
    
    public var data: Data {

        return map(\.data).reduce(Data(), +)
    }
}

extension Array : DataConvertible where Element : DataConvertible {
    
}
