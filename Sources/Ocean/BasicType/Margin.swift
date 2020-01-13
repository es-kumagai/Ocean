//
//  Margin.swift
//  ESSwim
//
//  Created by Tomohiro Kumagai on H27/07/29.
//
//

public struct Margin<Type> where Type : Numeric {
	
	public var top: Type
	public var right: Type
	public var bottom: Type
	public var left: Type

	public init(top: Type, right: Type, bottom: Type, left: Type) {
		
		self.top = top
		self.right = right
		self.bottom = bottom
		self.left = left
	}
}

extension Margin {

    public init(margin: Type) {
		
		self.init(top: margin, right: margin, bottom: margin, left: margin)
	}
	
	public init(vertical: Type, horizontal: Type) {
		
		self.init(top: vertical, right: horizontal, bottom: vertical, left: horizontal)
	}
	
	public init(top: Type, horizontal: Type, bottom: Type) {
		
		self.init(top: top, right: horizontal, bottom: bottom, left: horizontal)
	}
    
    public var horizontalTotal:Type {
        
        return self.left + self.right
    }
    
    public var verticalTotal:Type {
        
        return self.top + self.bottom
    }
}

// MARK: - Equatable

extension Margin : Equatable {
	
    public static func == <T:Equatable>(lhs:Margin<T>, rhs:Margin<T>) -> Bool {
        
        if case (lhs.top, lhs.right, lhs.bottom, lhs.left) = (rhs.top, rhs.right, rhs.bottom, rhs.left) {
            
            return true
        }
        else {
            
            return false
        }
    }
}

// MARK: - Type Aliases

public typealias IntMargin = Margin<Int>
