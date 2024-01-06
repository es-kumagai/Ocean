//
//  CSVStream.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/12/10.
//

import Swim

public final class CSVInputStream<Target> where Target : CSVLineConvertible {
    
    private let csv: CSV
    private let stream: TextFileInputStream

    public enum HandlingFirstLine {
    
        case includeInData
        case skipAsHeader
        case strictlyCheckAsHeader
    }
    
    public init(path: String, handlingFirstLine: HandlingFirstLine = .includeInData, csv: CSV = .standard) throws {
        
        self.csv = csv
        self.stream = try TextFileInputStream(path: path)
        
        switch handlingFirstLine {
        
        case .includeInData:
            break
            
        case .skipAsHeader:
            try stream.skipLine()
        
        case .strictlyCheckAsHeader:
            
            let expectedHeader = Self.header
            let actualHeader = try readAsHeader()
            
            guard expectedHeader == actualHeader else {
                
                throw FileStreamError.headerMismatch(expected: expectedHeader, actual: actualHeader)
            }
        }
    }
    
    public convenience init(path: String, target: Target.Type, handlingFirstLine: HandlingFirstLine = .includeInData, csv: CSV = .standard) throws {
        
        try self.init(path: path, handlingFirstLine: handlingFirstLine, csv: csv)
    }
    
    public static var header: [String] {
    
        return Target.csvColumns.map(\.name)
    }
    
    public var isEOF: Bool {
        
        return stream.isEOF
    }
    
    public func rewind() {
    
        stream.rewind()
    }
    
    public func skip() throws {
        
        try stream.skipLine()
    }
    
    public func read() throws -> Target? {
        
        guard let line = try stream.readLine() else {
            
            return nil
        }
        
        do {
        
            return try Target.init(csvLine: line, using: csv)
        }
        catch {
            
            throw FileStreamError.invalidLine(String(describing: error))
        }
    }
    
    public func readAsHeader() throws -> [String]? {
        
        guard let line = try stream.readLine() else {
            
            return nil
        }
        
        return csv.split(csv.removedTrailingNewline(of: line)).map { csv.extracted($0) ?? $0 }
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
    
    private let csv: CSV
    private let stream: TextFileOutputStream
    
    public init(path: String, mode: TextFileOutputStream.Mode = .overwrite, csv: CSV = .standard) throws {

        self.csv = csv
        self.stream = try TextFileOutputStream(path: path, mode: mode)
    }
    
    public convenience init(path: String, target: Target.Type, mode: TextFileOutputStream.Mode = .overwrite, csv: CSV = .standard) throws {
        
        try self.init(path: path, mode: mode, csv: csv)
    }
    
    public var mode: TextFileOutputStream.Mode {
        
        return stream.mode
    }
    
    public func flush() throws {
    
        try stream.flush()
    }
    
    public func write(_ value: Target) {
        
        stream.write(value.toCSVLine(using: csv))
    }
    
    public func errorDetectableWrite(_ value: Target) throws {
        
        try stream.errorDetectableWrite(value.toCSVLine(using: csv))
    }
    
    public func writeHeader() {
        
        stream.write(Target.csvHeaderLine(with: csv))
    }
    
    public func errorDetectableWriteHeader() throws {
        
        try stream.errorDetectableWrite(Target.csvHeaderLine(with: csv))
    }
}
