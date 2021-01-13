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
    
    func post()
}

extension NotificationProtocol {
    
    public static var notificationIdentifier: String {
        
        return "\(notificationIdentifierPrefix)\(type(of: self))"
    }
    
    public static var notificationName: Notification.Name {
        
        return .init(notificationIdentifier)
    }
    
    public var rawNotification: Notification {
        
        return Notification(name: Self.notificationName, object: self, userInfo: nil)
    }
}

extension Notification {
    
    public init<T: NotificationProtocol>(_ notification: T) {
        
        self = notification.rawNotification
    }
}

