//
//  UTSName.swift
//
//
//  Created by Tomohiro Kumagai on 2024/07/27.
//

import Foundation

public struct UTSName: ~Copyable {
    
    let utsname: UnsafeMutablePointer<utsname>
    
    public init() {
        utsname = .allocate(capacity: 1)
        uname(utsname)
    }
    
    deinit {
        utsname.deallocate()
    }
}

public extension UTSName {
    
    ///
    /// e.g. "arm64"
    var machine: String {
        withUnsafeBytes(of: &utsname.pointee.machine) { bytes in
            String(nullTerminatedBytes: bytes, encoding: .utf8)!
        }
    }
    
    /// 
    var nodeName: String {
        withUnsafeBytes(of: &utsname.pointee.nodename) { bytes in
            String(nullTerminatedBytes: bytes, encoding: .utf8)!
        }
    }
    
    ///
    /// e.g. "23.5.0"
    var releaseNumber: String {
        withUnsafeBytes(of: &utsname.pointee.release) { bytes in
            String(nullTerminatedBytes: bytes, encoding: .utf8)!
        }
    }
    
    ///
    /// e.g. "Darwin"
    var systemName: String {
        withUnsafeBytes(of: &utsname.pointee.sysname) { bytes in
            String(nullTerminatedBytes: bytes, encoding: .utf8)!
        }
    }
    
    ///
    /// e.g. "Darwin Kernel Version 23.5.0: Wed May  1 20:19:05 PDT 2024; root:xnu-10063.121.3~5/RELEASE_ARM64_T8112"
    var versionInformation: String {
        withUnsafeBytes(of: &utsname.pointee.version) { bytes in
            String(nullTerminatedBytes: bytes, encoding: .utf8)!
        }
    }
}
