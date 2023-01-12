//
//  StandardErrorStream.swift
//  
//  
//  Created by Tomohiro Kumagai on 2023/01/12
//  
//

import Foundation

public final class StandardErrorStream : FileHandleOutputStream {
    
    public init() {
        super.init(handle: FileHandle.standardError, encoding: .utf8)
    }
}
