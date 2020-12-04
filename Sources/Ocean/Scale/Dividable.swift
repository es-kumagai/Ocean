//
//  Dividable.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/01/14.
//

public protocol Dividable {
    
    associatedtype Value : Numeric
    
    var value: Value { get }
    var half: Value { get }
    var quarter: Value { get }
    
    static func /(lhs: Self, rhs: Self) -> Self
}

extension Dividable where Value : BinaryInteger {
    
    public var half: Value {
        
        value / 2
    }
    
    public var quarter: Value {
        
        value / 4
    }
}

extension Dividable where Value : BinaryFloatingPoint {
    
    public var half: Value {
        
        value / 2
    }
    
    public var quarter: Value {
        
        value / 4
    }
}

// MARK: - Type Extension

extension Int : Dividable {}
extension UInt : Dividable {}
extension Int8 : Dividable {}
extension UInt8 : Dividable {}
extension Int16 : Dividable {}
extension UInt16 : Dividable {}
extension Int32 : Dividable {}
extension UInt32 : Dividable {}
extension Int64 : Dividable {}
extension UInt64 : Dividable {}
extension Float : Dividable {}
extension Double : Dividable {}

#if !arch(arm64)
extension Float80 : Dividable {}
#endif
