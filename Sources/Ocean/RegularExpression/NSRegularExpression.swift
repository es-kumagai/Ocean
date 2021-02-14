//
//  NSRegularExpression.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 2021/02/15.
//

import Foundation

extension NSRegularExpression {
    
    public func enumerateMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], using block: (NSTextCheckingResult?, NSRegularExpression.MatchingFlags, UnsafeMutablePointer<ObjCBool>) -> Void) {
        
        let range = NSRange(location: 0, length: string.count)
        
        return enumerateMatches(in: string, options: options, range: range, using: block)
    }

    
    public func matches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
        
        let range = NSRange(location: 0, length: string.count)

        return matches(in: string, options: options, range: range)
    }

    public func numberOfMatches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> Int {
        
        let range = NSRange(location: 0, length: string.count)

        return numberOfMatches(in: string, options: options, range: range)
    }

    public func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = []) -> NSTextCheckingResult? {
        
        let range = NSRange(location: 0, length: string.count)

        return firstMatch(in: string, options: options, range: range)
    }

    public func rangeOfFirstMatch(in string: String, options: NSRegularExpression.MatchingOptions = []) -> NSRange {

        let range = NSRange(location: 0, length: string.count)

        return rangeOfFirstMatch(in: string, options: options, range: range)
    }
}
