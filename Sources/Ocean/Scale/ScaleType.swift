//
//  ScaleType.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/01/14.
//

public protocol ScaleType : Equatable {

    associatedtype Value : Numeric

    var value: Value { get }
    
    init(_ value: Value)
    
    /// The value is `true` if this instance means actual scale, otherwise `false`.
    var actualSize: Bool { get }
}

extension ScaleType {
    
    public func applying<Value : Scalable>(to value: Value) -> Value where Value.Scale == Self {
        
        return value.scaled(by: self)
    }
}
