//
//  File.swift
//  
//  
//  Created by Tomohiro Kumagai on 2023/01/20
//  
//

import Foundation

public final class LogDateFormatter {
    
    private let formatter: DateFormatter
    
    public init() {
        formatter = DateFormatter()
        
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
    }

    public func string(from date: Date) -> String {
        formatter.string(from: date)
    }
    
    public func logPrefix(with date: Date = Date(), processInfo: ProcessInfo = .processInfo, thread: pthread_t = pthread_self()) -> String {
        
        let processName = processInfo.processName
        let processID = processInfo.processIdentifier
        
        var threadID = 0 as UInt64
        pthread_threadid_np(thread, &threadID)

        return "\(string(from: date)) \(processName)[\(processID):\(threadID)]"
    }
}
