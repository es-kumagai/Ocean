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
        
        "\(notificationIdentifierPrefix)\(type(of: self))"
    }
    
    public static var notificationName: Notification.Name {
        
        Notification.Name(notificationIdentifier)
    }
    
    public var rawNotification: Notification {
        
        Notification(name: Self.notificationName, object: self, userInfo: nil)
    }
}

extension Notification {
    
    public init<T: NotificationProtocol>(_ notification: T) {
        
        self = notification.rawNotification
    }
}

