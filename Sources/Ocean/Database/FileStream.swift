//
//  FileStream.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/12/10.
//

import Foundation
import Swim

public enum FileStreamError : Error {

    case failedToOpen(path: String, description: String)
    case fileNotExists(path: String)
    case failedToRead
    case failedToWrite(String, description: String)
    case failedToFlush(description: String)
    case invalidLine(String)
    case headerMismatch(expected: [String], actual: [String]?)
}

public final class TextFileInputStream {
    
    public static var lineBufferInitialCapacity = 400
    
    private var handle: UnsafeMutablePointer<FILE>
    private var characterBuffer: UnsafeMutablePointer<CChar>
    
    public init(path: String) throws {
        
        guard Self.fileExists(atPath: path) else {
            
            throw FileStreamError.fileNotExists(path: path)
        }

        guard let handle = fopen(path, "r") else {

            throw FileStreamError.failedToOpen(path: path, description: CError.description)
        }
        
        let characterBufferlength = 2
        
        self.handle = handle
        self.characterBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: characterBufferlength)
        
        characterBuffer.initialize(repeating: 0, count: characterBufferlength)
    }
    
    deinit {
        
        fclose(handle)
        characterBuffer.deallocate()
    }
    
    public var isEOF: Bool {
    
        return feof(handle) != 0
    }
    
    public func rewind() {
        
        Darwin.rewind(handle)
    }
    
    public func readWord() throws -> String? {
        
        let word = fgetc(handle)
        
        guard word != EOF else {
            
            switch isEOF {

            case true:
                return nil
                
            case false:
                throw FileStreamError.failedToRead
            }
        }
        
        characterBuffer.pointee = CChar(word)

        return String(cString: characterBuffer)
    }
    
    public func readLine() throws -> String? {

        return try readUntil { $0 == "\n" }
    }
    
    public func readTo(_ word: String) throws -> String? {

        return try readUntil { $0 == word}
    }
    
    public func readTo(_ wordSet: Set<String>) throws -> String? {

        return try readUntil { wordSet.contains($0) }
    }
    
    public func readUntil(_ predicate: (String) -> Bool) throws -> String? {
        
        guard var result = try readWord() else {
            
            return nil
        }
        
        guard !predicate(result) else {
            
            return ""
        }
        
        result.reserveCapacity(Self.lineBufferInitialCapacity)
        
        while let word = try readWord() {
            
            guard !predicate(word) else {
                
                break
            }
            
            result.append(word)
        }
        
        return result
    }
    
    public func skipLine() throws {
        
        try skipTo("\n")
    }

    
    /// [Ocean] Skipping file location until a word specified by `word` appears.
    ///
    /// - Parameter word: The word to skipping file location to.
    /// - Throws: FileStreamError.failedToRead
    /// - Returns: If the word that appears at last location, returns true. Otherwise returns false.
    @discardableResult
    public func skipTo(_ word: String) throws -> Bool {
        
        while let currentWord = try readWord() {
            
            if currentWord == word {
                
                return true
            }
        }
        
        return false
    }
    
    /// [Ocean] Skipping file location until a word in `wordSet` appears.
    ///
    /// - Parameter wordSet: Words to skipping file location to.
    /// - Throws: FileStreamError.failedToRead
    /// - Returns: The word that appears at last location. If returns nil, the word listed in `wordSet` is not appeared.
    @discardableResult
    public func skipTo(_ wordSet: Set<String>) throws -> String? {
        
        return try skipUntil { wordSet.contains($0) }
    }
    
    @discardableResult
    public func skipUntil(_ predicate: (String) -> Bool) throws -> String? {
        
        while let word = try readWord() {
            
            if predicate(word) {
                
                return word
            }
        }
        
        return nil
    }
}

extension TextFileInputStream : IteratorProtocol, Sequence {
    
    public func next() -> String? {

        do {
        
            return try readLine()
        }
        catch {
            
            fatalError("\(error)")
        }
    }
}

extension TextFileInputStream {
    
    public static func fileExists(atPath path: String) -> Bool {
        
        var isDirectory = false as ObjCBool
        
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
        
            return !isDirectory.boolValue
        }
        else {
            
            return false
        }
    }
}

public final class TextFileOutputStream {
    
    public enum Mode : String {
        
        case overwrite = "w"
        case appending = "a"
    }
    
    private var handle: UnsafeMutablePointer<FILE>
    public private(set) var mode: Mode
    
    public init(path: String, mode: Mode = .overwrite) throws {
        
        guard let handle = fopen(path, mode.rawValue) else {

            throw FileStreamError.failedToOpen(path: path, description: CError.description)
        }
        
        self.handle = handle
        self.mode = mode
    }
    
    deinit {
        
        fclose(handle)
    }
    
    public func flush() throws {
        
        guard fflush(handle) != EOF else {
            
            throw FileStreamError.failedToFlush(description: CError.description)
        }
    }

    public func errorDetectableWrite(_ character: Character) throws {

        try errorDetectableWrite(String(character))
    }
    
    public func errorDetectableWrite<T>(_ string: T) throws where T : StringProtocol {
        
        guard fputs(string.description, handle) != EOF else {
            
            throw FileStreamError.failedToWrite(string.description, description: CError.description)
        }
    }
    
    public func errorDetectableWriteLine(_ string: String = "") throws {
        
        try errorDetectableWrite("\n")
    }
    
    public func errorDetectableWriteLine<T>(_ string: T) throws where T : StringProtocol {

        try errorDetectableWrite(string.description + "\n")
    }
}

extension TextFileOutputStream : TextOutputStream {

    public func write(_ character: Character) {
        
        write(String(character))
    }

    public func write(_ string: String) {

        fputs(string, handle)
    }
    
    public func writeLine(_ string: String = "") {
        
        write(string + "\n")
    }
    
    public func writeLine<T>(_ string: T) where T : StringProtocol {

        writeLine(string.description)
    }
}
