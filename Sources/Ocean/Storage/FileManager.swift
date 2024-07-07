//
//  FileManager.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/01/07
//  
//

import Foundation

public extension FileManager {
    
    /// [Ocean] Determines whether the `url` is a file.
    /// - Parameter url: The URL to be checked.
    /// - Returns: `true` if the item at the URL is a file, otherwise `false`.
    func isFile(at filePath: some FilePathConvertible) -> Bool {
        
        var isDirectory: ObjCBool = false
        
        guard fileExists(atPath: filePath.filePathDescription, isDirectory: &isDirectory) else {
            return false
        }
        
        return !isDirectory.boolValue
    }
    
    /// [Ocean] Determines whether the `url` is a directory.
    /// - Parameter url: The URL to be checked.
    /// - Returns: `true` if the item at the URL is a directory, otherwise `false`.
    @available(*, unavailable, renamed: "isDirectory(at:)", message: "This method was renamed.")
    func isDirectoryExists(at url: URL) -> Bool {
        fatalError()
    }

    /// [Ocean] Determines whether the `filePath` is a directory.
    /// - Parameter path: The URL to be checked.
    /// - Returns: `true` if the item at the URL is a directory, otherwise `false`.
    func isDirectory(at filePath: some FilePathConvertible) -> Bool {
        
        var isDirectory: ObjCBool = false
        
        guard fileExists(atPath: filePath.filePathDescription, isDirectory: &isDirectory) else {
            return false
        }
        
        return isDirectory.boolValue
    }
    
    func prepareDirectory(at filePath: some FilePathConvertible) throws {
        
        if !isDirectory(at: filePath) {
            
            try createDirectory(at: filePath.fileURLDescription, withIntermediateDirectories: true)
        }
    }

    func type(of filePath: some FilePathConvertible) -> FileAttributeType? {
        
        guard let attributes = try? attributesOfItem(atPath: filePath.filePathDescription) else {
            return nil
        }
        
        guard let `type` = attributes[.type] as? FileAttributeType else {
            return nil
        }
        
        return type
    }
    
    func isSymbolicLink(at filePath: some FilePathConvertible) -> Bool {
        
        type(of: filePath) == .typeSymbolicLink
    }
    
    func createSymbolicLink(at filePath: some FilePathConvertible, withDestinationURL destURL: URL, overwrite: Bool) throws {
        
        if overwrite, isSymbolicLink(at: filePath) {
            try removeItem(at: filePath.fileURLDescription)
        }

        try createSymbolicLink(at: filePath.fileURLDescription, withDestinationURL: destURL)
    }
}
