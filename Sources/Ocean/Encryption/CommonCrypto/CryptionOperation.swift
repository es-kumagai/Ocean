//
//  AESOperation.swift
//  CodePiece
//
//  Created by Tomohiro Kumagai on 2020/01/29.
//  Copyright © 2020 Tomohiro Kumagai. All rights reserved.
//

import CommonCrypto

extension Cryption {
    
    struct Operation : RawRepresentable {
        
        var rawValue: Int
    }
}

extension Cryption.Operation {
    
    static let encrypt = Self(rawValue: kCCEncrypt)
    static let decrypt = Self(rawValue: kCCDecrypt)
}
