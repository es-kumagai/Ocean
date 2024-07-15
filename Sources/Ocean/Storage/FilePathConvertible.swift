//
//  FilePathConvertible.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/07/06
//  
//

import Foundation

/// [Ocean] A type with a file path representation.
public protocol FilePathConvertible : Sendable {
    
    /// [Ocean] A textual file path representation of this instance.
    var filePathDescription: String { get }

    /// [Ocean] A URL representation of this instance.
    var fileURLDescription: URL { get }
}

public extension FilePathConvertible {
    
    /// [Ocean] A textual file path representation of this instance.
    var filePathDescription: String {
        fileURLDescription.path(percentEncoded: false)
    }
}

extension StringProtocol {
    
    /// [Ocean] A textual path representation of this instance.
    public var filePathDescription: String {
        description
    }
    
    /// [Ocean] A URL representation of this instance.
    public var fileURLDescription: URL {
        URL(fileURLWithPath: description)
    }
}

extension String : FilePathConvertible {
    
    public init(filePath: some FilePathConvertible) {
        self.init(filePath.filePathDescription)
    }
    
    /// [Ocean] A textual path representation of this instance.
    public var filePathDescription: String {
        description
    }
}

extension Substring : FilePathConvertible {
    
    /// [Ocean] A textual path representation of this instance.
    public var filePathDescription: String {
        description
    }
}

extension URL : FilePathConvertible {
    
    public init(filePath: some FilePathConvertible) {
        self = filePath.fileURLDescription
    }

    /// [Ocean] A textual path representation of this instance.
    public var filePathDescription: String {
        path(percentEncoded: false)
    }
    
    public var fileURLDescription: URL {
        self
    }
}

extension Sequence where Element : StringProtocol {
    
    public var fileURLDescription: URL {
        
        reduce(into: URL(filePath: "")) { url, component in
            url.append(component: component)
        }
    }
}

extension Array : FilePathConvertible where Element : StringProtocol {
}
