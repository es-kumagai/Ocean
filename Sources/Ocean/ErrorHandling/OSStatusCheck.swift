//
//  OSStatusCheck.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2024/06/03
//  
//

import Foundation

/// [Ocean] 
public struct ThrowingOnError<Status> : ~Copyable {
    
    public typealias Check = (Status) -> Bool
    public typealias Predicate = (Status) -> Error
    
    let check: Check
    let makeError: Predicate
    
    @inline(__always)
    init(check: @escaping Check, throwingError throwError: @escaping Predicate) {
        
        self.check = check
        self.makeError = throwError
    }
}

public extension ThrowingOnError {

    @inline(__always)
    static func && (status: Status, throwingOnError: consuming ThrowingOnError) throws {
        
        if !throwingOnError.check(status) {
            throw throwingOnError.makeError(status)
        }
    }
}

public extension ThrowingOnError where Status : Equatable {

    init(statusOnSuccess: Status, throwingError throwError: @escaping Predicate) {
        
        self.check = { $0 == statusOnSuccess }
        self.makeError = throwError
    }
}

@inline(__always)
public func throwingOnError<Status>(_ error: @escaping ThrowingOnError<Status>.Predicate, by check: @escaping ThrowingOnError<Status>.Check) throws -> ThrowingOnError<Status> {

    ThrowingOnError(check: check, throwingError: error)
}

@inline(__always)
public func throwingOnError<Status>(statusOnSuccess: Status, _ error: @escaping ThrowingOnError<Status>.Predicate) throws -> ThrowingOnError<Status> where Status : Equatable {

    ThrowingOnError(statusOnSuccess: statusOnSuccess, throwingError: error)
}

@inline(__always)
public func throwingOnError(_ error: @escaping ThrowingOnError<OSStatus>.Predicate) throws -> ThrowingOnError<OSStatus> {

    ThrowingOnError(statusOnSuccess: noErr, throwingError: error)
}
