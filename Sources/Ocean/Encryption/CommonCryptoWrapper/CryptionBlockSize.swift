//
//  CryptionBlockSize.swift
//  CodePiece
//
//  Created by Tomohiro Kumagai on 2020/01/29.
//  Copyright © 2020 Tomohiro Kumagai. All rights reserved.
//

import CommonCrypto

extension Cryption {
    
    struct BlockSize : RawRepresentable {
        
        var rawValue: Int
    }
}

extension Cryption.BlockSize {
    
    static let aes128 = Self(rawValue: kCCBlockSizeAES128)
    static let des = Self(rawValue: kCCBlockSizeDES)
    static let threeDes = Self(rawValue: kCCBlockSize3DES)
    static let cast = Self(rawValue: kCCBlockSizeCAST)
    static let rc2 = Self(rawValue: kCCBlockSizeRC2)
    static let blowfish = Self(rawValue: kCCBlockSizeBlowfish)
}
