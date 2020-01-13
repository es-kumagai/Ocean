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
    var meansActualSize: Bool { get }
}

extension ScaleType {
    
    public func applying<V : Scalable>(to value: V) -> Value where Value == V {
        
        self.value * value
    }
}

extension ScaleType where Value : ExpressibleByIntegerLiteral {
    
    public var meansActualSize: Bool {
        
        value == 1
    }
}

extension Int : ScaleType {}
extension UInt : ScaleType {}
extension Int8 : ScaleType {}
extension UInt8 : ScaleType {}
extension Int16 : ScaleType {}
extension UInt16 : ScaleType {}
extension Int32 : ScaleType {}
extension UInt32 : ScaleType {}
extension Int64 : ScaleType {}
extension UInt64 : ScaleType {}
extension Float : ScaleType {}
extension Double : ScaleType {}
extension Float80 : ScaleType {}
