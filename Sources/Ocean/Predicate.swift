//
//  Predicate.swift
//  BTCAtmosphere
//
//  Created by Tomohiro Kumagai on 12/11/17.
//

import Foundation

extension NSPredicate {
    
    public convenience init(name: String, between dateRange: Range<Date>) {

        self.init(format: "\(name) >= %@ AND \(name) < %@", dateRange.lowerBound as NSDate, dateRange.upperBound as NSDate)
    }
    
    public convenience init(name: String, between dateRange: ClosedRange<Date>) {
        
        self.init(format: "\(name) BETWEEN %@", [dateRange.lowerBound, dateRange.upperBound])
    }
    
    public convenience init(name: String, between dateRange: PartialRangeFrom<Date>) {
        
        self.init(format: "\(name) >= %@", dateRange.lowerBound as NSDate)
    }
    
    public convenience init(name: String, between dateRange: PartialRangeUpTo<Date>) {
        
        self.init(format: "\(name) < %@", dateRange.upperBound as NSDate)
    }
    
    public convenience init(name: String, between dateRange: PartialRangeThrough<Date>) {
        
        self.init(format: "\(name) <= %@", dateRange.upperBound as NSDate)
    }
    
    public convenience init(name: String, inYear year: Int) {
        
        let startDate = Date(year: year, month: 1, day: 1)
        let endDate = Date(year: year + 1, month: 1, day: 1)

        self.init(name: name, between: startDate ..< endDate)
    }
}
