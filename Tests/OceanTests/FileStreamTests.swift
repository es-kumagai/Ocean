//
//  FileStreamTests.swift
//  OceanTests
//
//  Created by Tomohiro Kumagai on 2020/12/10.
//

import XCTest
import Swim
@testable import Ocean

private struct CSVValue : CSVLineConvertible, Equatable {
    
    var id: Int
    var name: String
    var comment: String?
}

extension CSVValue {
    
    init(_ value: CSVValue) {
        
        self = value
    }
    
    @CSV.ColumnList
    static var csvColumns: [CSVColumn] {
        
        CSVColumn("id", keyPath: \.id)
        CSVColumn("name", keyPath: \.name)
        CSVColumn("comment", keyPath: \.comment)
    }
    
    static var csvDefaultValue: CSVValue = CSVValue(id: 0, name: "", comment: nil)
}

private struct CSVValue2 : CSVLineConvertible, Equatable {
    
    var id: Int
    var name: String
    var flag: Double?
}

extension CSVValue2 {
    
    init(_ value: CSVValue2) {
        
        self = value
    }
    
    @CSV.ColumnList
    static var csvColumns: [CSVColumn] {
        
        CSVColumn("id", keyPath: \.id)
        CSVColumn("name", keyPath: \.name)
        CSVColumn("flag", keyPath: \.flag)
    }
    
    static var csvDefaultValue = CSVValue2(id: 0, name: "", flag: nil)
}

class FileStreamTests: XCTestCase {

    func makeTemporaryFileURL(withExtension extension: String) -> URL {
     
        let uuid = UUID()
        
        return URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(uuid.description)
            .appendingPathExtension(`extension`)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReadWriteText() throws {
        
        let temporaryFileURL = makeTemporaryFileURL(withExtension: "txt")
        let temporaryFilePath = temporaryFileURL.path
        
        XCTAssertThrowsError(try TextFileInputStream(path: temporaryFilePath)) { error in
            
            guard let fileStreamError = error as? FileStreamError else {
                
                XCTFail("Unexpected error: \(error)")
                return
            }
            
            switch fileStreamError {
            
            case .fileNotExists:
                return
                
            default:
                XCTFail("Unexpected error: \(fileStreamError)")
            }
        }
        
        let output1 = try TextFileOutputStream(path: temporaryFilePath)
        
        XCTAssertEqual(output1.mode, .overwrite)
        
        output1.write("A")
        output1.write("BCD")
        output1.writeLine()
        
        output1.writeLine("EFGH")
        output1.writeLine()

        XCTAssertNoThrow(try output1.flush())
        
        let input1 = try TextFileInputStream(path: temporaryFilePath)
        
        XCTAssertFalse(input1.isEOF)
        let line1a = input1.next()
        XCTAssertFalse(input1.isEOF)
        let line2a = input1.next()
        XCTAssertFalse(input1.isEOF)
        let line3a = input1.next()
        XCTAssertFalse(input1.isEOF)
        let line4a = input1.next()
        XCTAssertTrue(input1.isEOF)

        XCTAssertEqual(line1a, "ABCD")
        XCTAssertEqual(line2a, "EFGH")
        XCTAssertEqual(line3a, "")
        XCTAssertNil(line4a)
        
        
        let output2 = try TextFileOutputStream(path: temporaryFilePath, mode: .appending)

        defer {
            
            do {
                
                try FileManager.default.removeItem(atPath: temporaryFilePath)
            }
            catch {
                
                XCTFail("\(error)")
            }
        }
        
        XCTAssertEqual(output2.mode, .appending)
        
        output2.writeLine("ABCD")
        output2.writeLine("EFGH")

        XCTAssertNoThrow(try output2.flush())
        
        let input2 = try TextFileInputStream(path: temporaryFilePath)
        
        XCTAssertFalse(input2.isEOF)
        try input2.skipLine()
        XCTAssertFalse(input2.isEOF)
        let line1b = input2.next()
        XCTAssertFalse(input2.isEOF)
        let line2b = input2.next()
        XCTAssertFalse(input2.isEOF)
        let line3b = input2.next()
        XCTAssertFalse(input2.isEOF)
        let line4b = input2.next()
        XCTAssertFalse(input2.isEOF)
        let line5b = input2.next()
        XCTAssertTrue(input2.isEOF)

        XCTAssertEqual(line1b, "EFGH")
        XCTAssertEqual(line2b, "")
        XCTAssertEqual(line3b, "ABCD")
        XCTAssertEqual(line4b, "EFGH")
        XCTAssertNil(line5b)
    }
    
    func testReadWriteCSV() throws {
        
        let temporaryFileURL = makeTemporaryFileURL(withExtension: "csv")
        let temporaryFilePath = temporaryFileURL.path
        
        XCTAssertThrowsError(try CSVInputStream(path: temporaryFilePath, target: CSVValue.self)) { error in
            
            guard let fileStreamError = error as? FileStreamError else {
                
                XCTFail("Unexpected error: \(error)")
                return
            }
            
            switch fileStreamError {
            
            case .fileNotExists:
                return
                
            default:
                XCTFail("Unexpected error: \(fileStreamError)")
            }
        }
        
        let output = try CSVOutputStream(path: temporaryFilePath, target: CSVValue.self)

        defer {
            
            do {
                
                try FileManager.default.removeItem(atPath: temporaryFilePath)
            }
            catch {
                
                XCTFail("\(error)")
            }
        }
        
        XCTAssertEqual(output.mode, .overwrite)
        
        let value1 = CSVValue(id: 8, name: "AB", comment: "TEST")
        let value2 = CSVValue(id: 16, name: "CD", comment: nil)
        
        try output.errorDetectableWriteHeader()
        try output.errorDetectableWrite(value1)
        try output.errorDetectableWrite(value2)

        XCTAssertNoThrow(try output.flush())
        
        let input = try CSVInputStream(path: temporaryFilePath, target: CSVValue.self)
        
        XCTAssertFalse(input.isEOF)
        let header = try input.readAsHeader()
        XCTAssertFalse(input.isEOF)
        let line1 = input.next()
        XCTAssertFalse(input.isEOF)
        let line2 = input.next()
        XCTAssertFalse(input.isEOF)
        let line3 = input.next()
        XCTAssertTrue(input.isEOF)

        XCTAssertEqual(header, CSVValue.csvColumns.map(\.name))
        XCTAssertEqual(line1, value1)
        XCTAssertEqual(line2, value2)
        XCTAssertNil(line3)

        XCTAssertNoThrow(try CSVInputStream<CSVValue2>(path: temporaryFilePath, handlingFirstLine: .includeInData))
        XCTAssertNoThrow(try CSVInputStream<CSVValue2>(path: temporaryFilePath, handlingFirstLine: .skipAsHeader))
        
        XCTAssertThrowsError(try CSVInputStream<CSVValue2>(path: temporaryFilePath, handlingFirstLine: .strictlyCheckAsHeader)) { error in
            
            guard let fileStreamError = error as? FileStreamError else {
                
                XCTFail("Unexpected error: \(error)")
                return
            }
            
            switch fileStreamError {
            
            case .headerMismatch(expected: let expected, actual: let actual):
                XCTAssertNotEqual(expected, actual)
                
            default:
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
}
