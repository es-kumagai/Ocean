//
//  Postable.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 12/12/17.
//

import Foundation

public protocol NotificationPostable {
    
}

extension NotificationPostable {
    
    public func post(_ notification: Notification) {
        
        notificationCenter.post(notification)
    }
    
    public func post(notificationNamed name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        
        notificationCenter.post(name: name, object: object, userInfo: userInfo)
    }
    
    public func post<T: NotificationProtocol>(_ notification: T) {
        
        notificationCenter.post(notification.rawNotification)
    }
}
