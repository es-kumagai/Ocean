//
//  Notification.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 12/12/17.
//

import Foundation

public internal(set) var notificationCenter = NotificationCenter.default
private let notificationIdentifierPrefix = "jp.ez-net.notification."

public protocol NotificationProtocol {
    
}

extension NotificationProtocol {
    
    internal static var notificationIdentifier: String {
        
        return "\(notificationIdentifierPrefix)\(type(of: self))"
    }
    
    internal static var notificationName: Notification.Name {
        
        return .init(notificationIdentifier)
    }
    
    internal var rawNotification: Notification {
        
        return Notification(name: Self.notificationName, object: self, userInfo: nil)
    }
}


