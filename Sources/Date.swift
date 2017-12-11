//
//  Date.swift
//  OceanPackageDescription
//
//  Created by Tomohiro Kumagai on 12/11/17.
//

import Foundation

extension Date {

    public init(year: Int, month: Int, day: Int, calendar: Calendar = Calendar(identifier: .gregorian)) {
        
        var components = DateComponents()
        
        components.year = year
        components.month = month
        components.day = day
        
        self = calendar.date(from: components)!
    }

    public func components(_ components: Set<Calendar.Component>, with calendar: Calendar = Calendar(identifier: .gregorian)) -> DateComponents {
        
        return calendar.dateComponents(components, from: self)
    }
}
