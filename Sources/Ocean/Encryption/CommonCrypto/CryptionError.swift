//
//  CryptionError.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/01/30.
//

import CommonCrypto

extension Cryption {
    
    public enum CryptionError : Error {
    
        case invalidArgument(message: String)
        case representingError
        
        case parameterError     /// Illegal parameter value. (kCCParamError)
        case bufferTooSmall     /// Insufficent buffer provided for specified operation. (kCCBufferTooSmall)
        case memoryFailure      /// Memory allocation failure. (kCCMemoryFailure)
        case alignmentError     /// Input size was not aligned properly. (kCCAlignmentError)
        case decodeError        /// Input data did not decode or decrypt properly. (kCCDecodeError)
        case unimplemented      /// Function not implemented for the current algorithm. (KCCUnimplemented)
        case overflow           /// kCCOverflow
        case rngFailure         /// kCCRNGFailure
        case unspecified        /// kCCUnspecifiedError
        case callSequenceError  /// kCCCallSequenceError
        case keySizeError       /// kCCKeySizeError
        case invalidKey         /// Key is not valid. (kCCInvalidKey)

        case unknownError(status: Int)
    }
}

extension Cryption.CryptionError {

    init?(_ status: CCCryptorStatus) {
        
        switch Int(status) {
            
        case kCCSuccess:
            return nil
            
        case kCCParamError:
            self = .parameterError
            
        case kCCBufferTooSmall:
            self = .bufferTooSmall
            
        case kCCMemoryFailure:
            self = .memoryFailure
            
        case kCCAlignmentError:
            self = .alignmentError
            
        case kCCDecodeError:
            self = .decodeError
            
        case kCCUnimplemented:
            self = .unimplemented
            
        case kCCOverflow:
            self = .overflow
            
        case kCCRNGFailure:
            self = .rngFailure
            
        case kCCUnspecifiedError:
            self = .unspecified
            
        case kCCCallSequenceError:
            self = .callSequenceError
            
        case kCCKeySizeError:
            self = .keySizeError
            
        case kCCInvalidKey:
            self = .invalidKey

        default:
            self = .unknownError(status: Int(status))
        }
    }
}
