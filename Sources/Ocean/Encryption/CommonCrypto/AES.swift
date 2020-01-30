//
//  AES.swift
//  CodePiece
//
//  Created by Tomohiro Kumagai on 2020/01/29.
//  Copyright © 2020 Tomohiro Kumagai. All rights reserved.
//

import Foundation
import CommonCrypto

extension Cryption {
    
	public class AES : Cipher {
        
        public static let initialVectorSize = BlockSize.aes128.rawValue
        public static let sharedKeySize = KeySize.aes128.rawValue
        
        private var sharedKey: UnsafeMutableBufferPointer<UInt8>
		private var defaultInitialVectorData: Data?
        
		public convenience init?(sharedKey keyString: String, initialVector ivData: Data? = nil) {
            
            guard let keyData = keyString.data(using: .ascii) else {
                
                return nil
            }
            
			self.init(sharedKey: keyData, initialVector: ivData)
        }
        
        public init?(sharedKey keyData: Data, initialVector ivData: Data? = nil) {
            
            guard let keyBuffer = keyData.copyBytes() else {
                
                return nil
            }
			
            sharedKey = keyBuffer
			defaultInitialVectorData = ivData
        }
        
        deinit {
            
            CCRandomGenerateBytes(sharedKey.baseAddress, sharedKey.count)
            sharedKey.deallocate()
        }
        
        public func encrypto(_ text: String, initialVector ivData: Data? = nil) throws -> Data {
			
			guard let ivData = ivData ?? defaultInitialVectorData else {
			
                throw Cryption.CryptionError.invalidArgument(message: "Initial vector is not specified.")
			}
			
            guard ivData.count == AES.initialVectorSize else {
                
                throw Cryption.CryptionError.invalidArgument(message: "Invalid initial vector size passed as an argument.")
            }
            
            guard let textData = text.data(using: .utf8), let textBuffer = textData.copyBytes() else {
                
                throw Cryption.CryptionError.invalidArgument(message: "Invalid text passed as an argument.")
            }
            
            defer {
                
                textBuffer.deallocate()
            }
            
            guard let ivBuffer = ivData.copyBytes() else {
                
                throw CryptionError.invalidArgument(message: "Invalid initial vector passed as an argument.")
            }
            
            defer {
                
                ivBuffer.deallocate()
            }
            
            let cryptedBufferLength = Int(ceil(Double(textData.count / BlockSize.aes128.rawValue)) + 1) * BlockSize.aes128.rawValue
            let cryptedBuffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: cryptedBufferLength)
            
            defer {
                
                cryptedBuffer.deallocate()
            }
            
            var encryptionByteCount = 0
            
            let status = CCCrypt(
                CCOperation(Operation.encrypt.rawValue),
                CCAlgorithm(Algorithm.aes.rawValue),
                CCOptions(Option.pkcs7Padding.rawValue),
                sharedKey.baseAddress,
                sharedKey.count,
                ivBuffer.baseAddress,
                textBuffer.baseAddress,
                textBuffer.count,
                cryptedBuffer.baseAddress,
                cryptedBufferLength,
                &encryptionByteCount)
            
            if let error = Cryption.CryptionError(status) {
                
                throw error
            }
            
            return Data(cryptedBuffer)
        }
        
        public func decrypto(_ cryptedTextData: Data, initialVector ivData: Data? = nil) throws -> String {
            
			guard let ivData = ivData ?? defaultInitialVectorData else {
			
                throw Cryption.CryptionError.invalidArgument(message: "Initial vector is not specified.")
			}

			guard ivData.count == AES.initialVectorSize else {
                
                throw CryptionError.invalidArgument(message: "Invalid initial vector size passed as an argument.")
            }
            
            guard let cryptedTextBuffer = cryptedTextData.copyBytes() else {
                
                throw CryptionError.invalidArgument(message: "Invalid crypted text passed as an argument.")
            }
            
            defer {
                
                cryptedTextBuffer.deallocate()
            }
            
            guard let ivBuffer = ivData.copyBytes() else {
                
                throw CryptionError.invalidArgument(message: "Invalid initial vector passed as an argument.")
            }
            
            defer {
                
                ivBuffer.deallocate()
            }
            
            let clearTextDataLength = cryptedTextData.count + BlockSize.aes128.rawValue
            var clearTextData = Data(count: clearTextDataLength)
            
            var decryptionByteCount = 0
            
            let status = clearTextData.withUnsafeMutableBytes { clearTextBuffer in
                
                CCCrypt(
                    CCOperation(Operation.decrypt.rawValue),
                    CCAlgorithm(Algorithm.aes.rawValue),
                    CCOptions(Option.pkcs7Padding.rawValue),
                    sharedKey.baseAddress,
                    sharedKey.count,
                    ivBuffer.baseAddress,
                    cryptedTextBuffer.baseAddress,
                    cryptedTextBuffer.count,
                    clearTextBuffer.baseAddress,
                    clearTextBuffer.count,
                    &decryptionByteCount)
            }
            
            if let error = CryptionError(status) {
                
                throw error
            }
            
            
            guard let clearText = String(bytes: clearTextData.prefix(decryptionByteCount), encoding: .ascii) else {
                
                throw CryptionError.representingError
            }
            
            return clearText
            
        }
    }
}
