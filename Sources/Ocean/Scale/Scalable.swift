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

extension Double : ScaleType & Scalable {
    
    public var value: Double {
    
        self
    }
    
    public init(_ value: Double) {
        
        self = value
    }
    
    public func scaled(by scale: Scale<Double>) -> Double {
        
        self * scale.value
    }
}

extension Float : ScaleType & Scalable {
    
    public var value: Float {
    
        self
    }
    
    public init(_ value: Float) {
        
        self = value
    }

    public func scaled(by scale: Scale<Float>) -> Float {
        
        self * scale.value
    }
}
