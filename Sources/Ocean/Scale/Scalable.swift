//
//  Scalable.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/01/14.
//

public protocol Scalable {
    
    associatedtype Scale : ScaleType
    
    func scaled(by scale: Scale) -> Self
}

public protocol HavingScale {
    
    associatedtype Scale : ScaleType
    
    var scale: Scale { get }
}

extension Scalable {

    public func scaled<T: HavingScale>(by item: T) -> Self where Scale == T.Scale {
        
        return scaled(by: item.scale)
    }
}

extension BinaryInteger where Self : Scalable, Scale.Value == Self {
    
    public func scaled<T: ScaleType>(by scale: T) -> Self where T.Value == Self {
        
        scale.applying(to: value)
    }
}

extension BinaryFloatingPoint where Self : Scalable, Scale.Value == Self {
    
    public func scaled<T: ScaleType>(by scale: T) -> Self where T.Value == Self {
        
        scale.applying(to: value)
    }
}

extension Int : Scalable {
    public typealias Scale = Int
}

extension UInt : Scalable {
    public typealias Scale = UInt
}

extension Int8 : Scalable {
    public typealias Scale = Int8
}

extension UInt8 : Scalable {
    public typealias Scale = UInt8
}

extension Int16 : Scalable {
    public typealias Scale = Int16
}

extension UInt16 : Scalable {
    public typealias Scale = UInt16
}

extension Int32 : Scalable {
    public typealias Scale = Int32
}

extension UInt32 : Scalable {
    public typealias Scale = UInt32
}

extension Int64 : Scalable {
    public typealias Scale = Int64
}

extension UInt64 : Scalable {
    public typealias Scale = UInt64
}

extension Float : Scalable {
    public typealias Scale = Float
}

extension Double : Scalable {
    public typealias Scale = Double
}

extension Float80 : Scalable {
    public typealias Scale = Float80
}

