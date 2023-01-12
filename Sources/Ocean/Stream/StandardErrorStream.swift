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

var standardErrorStream = StandardErrorStream()

public func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    
    let text = items.map(String.init(describing:)).joined(separator: separator)
    print(text, terminator: terminator, to: &standardErrorStream)
}
