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

extension Double : Scalable {
    
    public func scaled(by scale: Scale<Double>) -> Double {
        
        self * scale.value
    }
}

extension Float : Scalable {
    
    public func scaled(by scale: Scale<Float>) -> Float {
        
        self * scale.value
    }
}
