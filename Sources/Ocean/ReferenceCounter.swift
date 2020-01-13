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
        
        ReferenceCounter.queue.sync {
            
            _count
        }
    }
    
    public var isRetained: Bool {
        
        ReferenceCounter.queue.sync {
            
            _count != 0
        }
    }
    
    public mutating func countRetain(adding count: Int = 1) {
        
        ReferenceCounter.queue.sync {
            
            _count += count
        }
    }
    
    public mutating func countRelease() {
        
        ReferenceCounter.queue.sync {
            
            if _count > 0 {
                
                _count -= 1
            }
        }
    }
    
    public mutating func countReset() {
        
        ReferenceCounter.queue.sync {
            
            _count = 0
        }
    }
}

extension ReferenceCounter {
    
    static let queue = DispatchQueue(label: "jp.ez-net.Ocean.ReferenceCounter")
}
