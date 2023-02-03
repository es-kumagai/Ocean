//
//  FileHandleOutputStream.swift
//  
//  
//  Created by Tomohiro Kumagai on 2023/01/12
//  
//

import Foundation

open class FileHandleOutputStream : TextOutputStream, @unchecked Sendable {
    
    public typealias Finalizer = @Sendable (_ handle: FileHandle) -> Void
    
    let handle: FileHandle
    let encoding: String.Encoding
    let finalizer: Finalizer?
    
    public init(handle: FileHandle, encoding: String.Encoding = .utf8, finalizer: Finalizer? = nil) {

        self.handle = handle
        self.encoding = encoding
        self.finalizer = finalizer
    }
    
    deinit {
        finalizer?(handle)
    }
}

extension FileHandleOutputStream {
    
    public func write(_ string: String) {

        guard let data = string.data(using: encoding) else {
            fatalError("Failed to encoding the string.")
        }
        
        do {
            try handle.write(contentsOf: data)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

private let logDateFormatter = LogDateFormatter()

public func output(_ items: Any..., to stream: inout some TextOutputStream, separator: String = " ", terminator: String = "\n", logPrefix: Bool = false, logPrefixSeparator: String = " ") {
    
    output(contentsOf: items, to: &stream)
}

public func output(contentsOf items: [Any], to stream: inout some TextOutputStream, separator: String = " ", terminator: String = "\n", logPrefix: Bool = false, logPrefixSeparator: String = " ") {
    
    let text = items.map(String.init(describing:)).joined(separator: separator)
    let prefix = !text.isEmpty && logPrefix ? logDateFormatter.logPrefix() + logPrefixSeparator : ""
    
    print("\(prefix)\(text)", terminator: terminator, to: &stream)
}
