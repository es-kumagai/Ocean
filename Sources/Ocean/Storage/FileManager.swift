//
//  FileManager.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/01/07
//  
//

import Foundation

extension FileManager {
    
    public func isSymbolicLink(atPath path: String) -> Bool {
        
        guard let attributes = try? attributesOfItem(atPath: path) else {
            return false
        }
        
        guard let `type` = attributes[.type] as? FileAttributeType else {
            return false
        }
        
        return type == .typeSymbolicLink
    }
    
    public func createSymbolicLink(at url: URL, withDestinationURL destURL: URL, overwrite: Bool) throws {
        
        if overwrite, isSymbolicLink(atPath: url.path) {
            try removeItem(at: url)
        }

        try createSymbolicLink(at: url, withDestinationURL: destURL)
    }
}
