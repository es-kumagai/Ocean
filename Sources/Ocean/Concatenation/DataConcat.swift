//
//  DataConcat.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2021/02/14.
//

import Foundation

/// [Ocean] A data processor that can be used in data concatenation supplied by `DataConcat` result builder.
public struct DataConcatProcess {
    
    fileprivate var predicate: (Data) -> Data
    
    public init(_ predicate: @escaping (Data) -> Data) {
        
        self.predicate = predicate
    }
}

extension DataConcatProcess {
    
    /// [Ocean] Returns a data processor that convert a data to the subdata containing all but the specified number of final elements.
    /// - Parameter k: The number of final elements that will be dropped.
    public static func dropLast(_ k: Int = 1) -> DataConcatProcess {
     
        DataConcatProcess {

            $0.dropLast(k)
        }
    }
    
    /// [Ocean] Returns a data processor that combine two data.
    /// - Parameter value: The data that will be appended to other data.
    public static func appending<T : DataConvertible>(_ value: T) -> DataConcatProcess {
        
        DataConcatProcess{
            
            $0 + value.data
        }
    }
    
    /// [Ocean] Returns a data processor that makes a data repeating `value` specified times.
    /// - Parameters:
    ///   - value: The data to repeat.
    ///   - count: The number of times to repeat the value passed in the repeating parameter. count must be zero or greater.
    public static func repeating<T : DataConvertible>(_ value: T, count: Int) -> DataConcatProcess {
        
        DataConcatProcess {
            
            Array(repeating: value.data, count: count).reduce($0, +)
        }
    }
}

/// [Ocean] A result builder to concatenate multiple data.
@_functionBuilder
public struct DataConcat {

    public static func buildFinalResult(_ component: DataConcatProcess) -> Data {
        
        return component.predicate(Data())
    }
    
    public static func buildExpression<T : DataConvertible>(_ expression: T) -> DataConcatProcess {
        
        return .appending(expression.data)
    }
    
    public static func buildExpression(_ expression: DataConcatProcess) -> DataConcatProcess {
        
        return expression
    }
    
    public static func buildBlock(_ components: DataConcatProcess...) -> DataConcatProcess {
        
        return DataConcatProcess {

            components.reduce($0) { data, process in process.predicate(data) }
        }
    }
    
    public static func buildEither(first component: DataConcatProcess) -> DataConcatProcess {
        
        return DataConcatProcess(component.predicate)
    }
    
    public static func buildEither(second component: DataConcatProcess) -> DataConcatProcess {
        
        return DataConcatProcess(component.predicate)
    }
    
    public static func buildOptional(_ component: DataConcatProcess?) -> DataConcatProcess {
        
        guard let component = component else {
            
            return DataConcatProcess { $0 }
        }
        
        return DataConcatProcess(component.predicate)
    }
    
    public static func buildArray(_ components: [DataConcatProcess]) -> DataConcatProcess {
        
        return DataConcatProcess {
            
            components.reduce($0) { data, process in process.predicate(data) }
        }
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
