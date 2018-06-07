//
//  ReferenceCounter.swift
//  Swim
//
//  Created by Tomohiro Kumagai on 12/13/17.
//

import Dispatch

public struct ReferenceCounter {
    
    private var _count: Int
    
    public init() {
    
        _count = 0
    }

    public var count: Int {
    
        return ReferenceCounter.queue.sync {
            
            return _count
        }
    }
    
    public var retained: Bool {
        
        return ReferenceCounter.queue.sync {

            _count != 0
        }
    }
    
    public mutating func retain(adding count: Int = 1) {
        
        ReferenceCounter.queue.sync {
            
            _count += count
        }
    }
    
    public mutating func release() {
        
        ReferenceCounter.queue.sync {

            if _count > 0 {
                
                _count -= 1
            }
        }
    }
}

extension ReferenceCounter {
    
    static let queue = DispatchQueue(label: "jp.ez-net.Ocean.ReferenceCounter")
}
