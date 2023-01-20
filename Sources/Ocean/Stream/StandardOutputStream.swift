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

var standardOutputStream = StandardOutputStream()

public func output(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    
    let text = items.map(String.init(describing:)).joined(separator: separator)
    print(text, terminator: terminator, to: &standardErrorStream)
}
