//
//  Data.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2024/06/05
//  
//

import Foundation
import Swim

public extension Data {
    
    /// [Ocean] Returns a newly allocated buffer that is a copy of this instance. The caller is responsible for freeing the allocated memory after use.
    func copiedBytes() -> UnsafeMutableBufferPointer<Byte>? {
        
        let result = UnsafeMutableBufferPointer<Byte>.allocate(capacity: count)
        let resultWroteCount = copyBytes(to: result)
        
        guard resultWroteCount == count else {
            
            result.deallocate()
            return nil
        }
        
        return result
    }
}

public extension Sequence<Data> {
    
    /// [Ocean] Returns the maximum size of `Data` elements
    /// in the given sequence.
    var maxSize: Int {
        
        borrowing get {
            
            reduce(into: 0) { maxSize, data in
                
                let size = data.count
                
                if size > maxSize {
                    maxSize = size
                }
            }
        }
    }
}
