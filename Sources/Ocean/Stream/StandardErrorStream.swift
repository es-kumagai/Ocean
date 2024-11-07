//
//  StandardErrorStream.swift
//  
//  
//  Created by Tomohiro Kumagai on 2023/01/12
//  
//

import Foundation

public final class StandardErrorStream : FileHandleOutputStream, @unchecked Sendable {
    
    public init() {
        super.init(handle: FileHandle.standardError, encoding: .utf8)
    }
}

private let logDateFormatter = LogDateFormatter()
private var standardErrorStream = StandardErrorStream()

public func error(_ items: Any..., separator: String = " ", terminator: String = "\n", logPrefix: Bool = false, logPrefixSeparator: String = " ") {
    
    output(contentsOf: items, to: &standardErrorStream, separator: separator, terminator: terminator, logPrefix: logPrefix, logPrefixSeparator: logPrefixSeparator)
}
