//
//  Chiper.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/01/30.
//

import Foundation

public protocol Cipher {
	
	func encrypto(_ text: String, initialVector ivData: Data?) throws -> Data
	func decrypto(_ cryptedTextData: Data, initialVector ivData: Data?) throws -> String
}
