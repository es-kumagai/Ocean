//
//  DataConcat.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2021/02/14.
//

import Foundation

/// [Ocean] A result builder to concatenate multiple data.
@_functionBuilder
public struct DataConcat {

    public static func buildExpression<T : DataConvertible>(_ expression: T) -> Data {
        
        return expression.data
    }
    
    public static func buildBlock(_ components: Data...) -> Data {
        
        return components
            .reduce(Data(), +)
    }
    
    public static func buildEither(first component: Data) -> Data {
        
        return component
    }
    
    public static func buildEither(second component: Data) -> Data {
        
        return component
    }
    
    public static func buildOptional(_ component: Data?) -> Data {
        
        return component.data
    }
    
    public static func buildArray(_ components: [Data]) -> Data {
        
        return components.data
    }
}

extension Data {
    
    /// [Ocean] Build data that is concatenated multiple data.
    /// - Parameter predicate: A function that concatenate multiple data.
    /// - Returns: A data that concatenated multiple data.
    public static func concat(@DataConcat _ predicate: () throws -> Data) rethrows -> Data {
        
        return try predicate()
    }
}
