//
//  StandardOutputStream.swift
//  
//  
//  Created by Tomohiro Kumagai on 2023/01/12
//  
//

import Foundation

public final class StandardOutputStream : FileHandleOutputStream {
    
    public init() {
        super.init(handle: FileHandle.standardOutput, encoding: .utf8)
    }
}

public let standardOutputStream = StandardOutputStream()
