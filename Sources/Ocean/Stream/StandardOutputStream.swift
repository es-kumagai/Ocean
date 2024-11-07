//
//  StandardOutputStream.swift
//  
//  
//  Created by Tomohiro Kumagai on 2023/01/12
//  
//

import Foundation

public final class StandardOutputStream : FileHandleOutputStream, @unchecked Sendable {
    
    public init() {
        super.init(handle: FileHandle.standardOutput, encoding: .utf8)
    }
}

private let logDateFormatter = LogDateFormatter()
private var standardOutputStream = StandardOutputStream()

public func output(_ items: Any..., separator: String = " ", terminator: String = "\n", logPrefix: Bool = false, logPrefixSeparator: String = " ") {
    
    output(contentsOf: items, to: &standardOutputStream, separator: separator, terminator: terminator, logPrefix: logPrefix, logPrefixSeparator: logPrefixSeparator)
}
