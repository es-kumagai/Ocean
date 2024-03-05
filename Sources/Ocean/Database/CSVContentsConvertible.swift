//
//  CSVContentsConvertible.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/03/06
//  
//

import Foundation
import Swim

public extension CSVContentsConvertible {
        
    func writeCSVContents(to url: URL, includesHeaderLine: Bool = true, atomically useAuxiliaryFile: Bool = true, encoding: String.Encoding = .utf8) throws {
        try csvContentsDescription(includesHeaderLine: includesHeaderLine).write(to: url, atomically: useAuxiliaryFile, encoding: encoding)
    }
}
