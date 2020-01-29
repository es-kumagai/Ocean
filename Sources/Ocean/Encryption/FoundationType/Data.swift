//
//  Data.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/01/30.
//

import Foundation

extension Data {
    
    /// [Ocean] Returns copied buffer.
    public func copyBytes() -> UnsafeMutableBufferPointer<UInt8>? {
        
        let result = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: count)
        let resultWroteCount = copyBytes(to: result)
        
        guard resultWroteCount == count else {
            
            result.deallocate()
            return nil
        }
        
        return result
    }
}
