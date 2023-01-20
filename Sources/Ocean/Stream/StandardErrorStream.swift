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

private let logDateFormatter = LogDateFormatter()
private var standardErrorStream = StandardErrorStream()

public func error(_ items: Any..., separator: String = " ", terminator: String = "\n", logPrefix: Bool = false, logPrefixSeparator: String = " ") {
    
    let text = items.map(String.init(describing:)).joined(separator: separator)
    let prefix = !text.isEmpty && logPrefix ? logDateFormatter.logPrefix() : ""
    
    print("\(prefix)\(text)", terminator: terminator, to: &standardErrorStream)
}
