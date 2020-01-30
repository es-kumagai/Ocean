//
//  Options.swift
//  CodePiece
//
//  Created by Tomohiro Kumagai on 2020/01/29.
//  Copyright © 2020 Tomohiro Kumagai. All rights reserved.
//

import CommonCrypto

extension Cryption {
    
    struct Option : OptionSet {
        
        var rawValue: Int
    }
}

extension Cryption.Option {
    
    static let pkcs7Padding = Self(rawValue: kCCOptionPKCS7Padding)
    static let ecbMode = Self(rawValue: kCCOptionECBMode)
}
