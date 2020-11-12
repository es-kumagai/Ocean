//
//  SQLite3.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2020/11/12.
//

import Foundation
import Swim

extension SQLite3 {
    
    public func makeStatement(fromResource resource: String, ofType type: String, bundle: Bundle? = nil, prepare: ((Statement) throws -> Void)? = nil) throws -> Statement {
        
        let bundle = bundle ?? Bundle.main
        let path = bundle.path(forResource: resource, ofType: type)!
        
        let sql = try String(contentsOfFile: path)
        
        return try makeStatement(with: sql, prepare: prepare)
    }

    @discardableResult
    public func execute(usingResource resource: String, ofType type: String, bundle: Bundle? = nil, prepare: ((Statement) throws -> Void)? = nil) throws -> Statement? {
        
        let bundle = bundle ?? Bundle.main
        let path = bundle.path(forResource: resource, ofType: type)!
        
        let sql = try String.init(contentsOfFile: path)
        
        return try execute(sql: sql, prepare: prepare)
    }

    public convenience init(url: URL, options: OpenOption) throws {
        
        try self.init(store: Store.path(url.path), options: options)
    }
}
