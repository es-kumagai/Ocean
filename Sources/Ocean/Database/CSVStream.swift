//
//  CSVStream.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/12/10.
//

import Swim

public final class CSVInputStream<Target> where Target : CSVLineConvertible {
    
    private var stream: TextFileInputStream

    public init(path: String) throws {
        
        stream = try TextFileInputStream(path: path)
    }
    
    public convenience init(path: String, target: Target.Type) throws {
        
        try self.init(path: path)
    }
    
    public var isEOF: Bool {
        
        return stream.isEOF
    }
    
    public func rewind() {
    
        stream.rewind()
    }
    
    public func read() throws -> Target? {
        
        guard let line = try stream.readLine() else {
            
            return nil
        }
        
        do {
        
            return try Target.init(csvLine: line)
        }
        catch {
            
            throw FileStreamError.invalidLine(String(describing: error))
        }
    }
}

extension CSVInputStream : IteratorProtocol, Sequence {
    
    public func next() -> Target? {

        do {
        
            return try read()
        }
        catch {
            
            fatalError("\(error)")
        }
    }
}

public final class CSVOutputStream<Target> where Target : CSVLineConvertible {
    
    private var stream: TextFileOutputStream
    
    public init(path: String, mode: TextFileOutputStream.Mode = .overwrite) throws {

        stream = try TextFileOutputStream(path: path, mode: mode)
    }
    
    public convenience init(path: String, target: Target.Type, mode: TextFileOutputStream.Mode = .overwrite) throws {
        
        try self.init(path: path, mode: mode)
    }
    
    public var mode: TextFileOutputStream.Mode {
        
        return stream.mode
    }
    
    public func flush() throws {
    
        try stream.flush()
    }
    
    public func write(_ value: Target) throws {
        
        stream.write(value.toCSVLine())
    }
    
    public func errorDetectableWrite(_ value: Target) throws {
        
        try stream.errorDetectableWrite(value.toCSVLine())
    }
}
