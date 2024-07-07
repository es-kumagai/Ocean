//
//  URLResourceError.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/07/06
//  
//

import Foundation

public enum URLResourceError : Error {
    
    case resourceNotFound(URLResourceKey)
}
