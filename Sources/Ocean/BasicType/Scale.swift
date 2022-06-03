//
//  Scale.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/01/14.
//

public struct Scale<T> : ScaleType where T : Numeric {
    
    public var value: T
    
    public init(_ value: T) {
        
        self.value = value
    }
}

extension Scale : Sendable where T : Sendable {
    
}

extension Scale : ExpressibleByIntegerLiteral where T : _ExpressibleByBuiltinIntegerLiteral {
    
    public init(integerLiteral value: T) {
        
        self.init(value)
    }
}

extension Scale : ExpressibleByFloatLiteral where T : _ExpressibleByBuiltinFloatLiteral {
    
    public init(floatLiteral value: T) {
        
        self.init(value)
    }
}

extension Scale : CustomStringConvertible {
    
    public var description:String {
        
        return String(describing: value)
    }
}

extension Scale : Equatable {
    
}
