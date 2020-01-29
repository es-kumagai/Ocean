//
//  CommonCryptoTests.swift
//  OceanTests
//
//  Created by Tomohiro Kumagai on 2020/01/30.
//

import XCTest
@testable import Ocean

class CommonCryptoTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEncryptionState() {
        
        XCTAssertEqual(Cryption.AES.initialVectorSize, 16)
        XCTAssertEqual(Cryption.AES.sharedKeySize, 16)
        
        XCTAssertEqual(Cryption.AES.generateRandomInitialVectorData().count, 16)
        XCTAssertEqual(Cryption.AES.generateRandomSharedKeyData().count, 16)
    }
    
    func testEncryptionStatic() {
        
        do {
            
            let ivStatic = "rPU\\Xs^RUBiwz;w1".data(using: .ascii)
            let sharedKey = "Sa||`w\'(,3oIq]ZQ"
            let chiper = Cryption.AES(sharedKey: sharedKey)!
            
            let clearText = "Ocean @ EZ-NET"
            let encryptedData = try chiper.encrypto(clearText, initialVector: ivStatic)
            let decryptedText = try chiper.decrypto(encryptedData, initialVector: ivStatic)
            
            //            XCTAssertEqual(encryptedData, "")
            XCTAssertEqual(decryptedText, clearText)
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testEncryptionRandom() {
        
        do {
            
            let ivRandom = Cryption.AES.generateRandomInitialVectorData()
            let sharedKey = Cryption.AES.generateRandomSharedKeyData()
            let chiper = Cryption.AES(sharedKey: sharedKey)!
            
            let clearText = "Ocean @ EZ-NET"
            let encryptedData = try chiper.encrypto(clearText, initialVector: ivRandom)
            let decryptedText = try chiper.decrypto(encryptedData, initialVector: ivRandom)
            
            XCTAssertEqual(decryptedText, clearText)
            
            print("iv", ivRandom)
            print("encryptedText", encryptedData)
        }
        catch {
            XCTFail("\(error)")
        }
    }
    
    func testEncryptionDifferentIv() {
        
        do {
            
            let iv1 = Cryption.AES.generateRandomInitialVectorData()
            let iv2 = Cryption.AES.generateRandomInitialVectorData()
            let sharedKey = Cryption.AES.generateRandomSharedKeyData()
            let chiper = Cryption.AES(sharedKey: sharedKey)!
            
            let clearText = "Ocean @ EZ-NET"
            let encryptedData = try chiper.encrypto(clearText, initialVector: iv1)
            
            do {
                let decryptedText = try chiper.decrypto(encryptedData, initialVector: iv2)
                
                XCTAssertNotEqual(decryptedText, clearText)
            }
            catch Cryption.CryptionError.representingError {
             
                // Expected.
            }
        }
        catch {
            XCTFail("\(error)")
        }
        
    }
    
}
