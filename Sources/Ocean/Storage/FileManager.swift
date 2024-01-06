//
//  FileManager.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/01/07
//  
//

import Foundation

extension FileManager {
    
    public func isDirectoryExists(at url: URL) -> Bool {
        
        var isDirectory: ObjCBool = false
        
        guard fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            return false
        }
        
        return isDirectory.boolValue
    }
    
    public func prepareDirectory(at url: URL) throws {
        
        if !isDirectoryExists(at: url) {
            
            try createDirectory(at: url, withIntermediateDirectories: true)
        }
    }
    
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
