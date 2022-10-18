//
//  NotificationPost.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 12/12/17.
//

import Foundation

#if os(iOS)
extension Notification {
    
    public func post() {
        
        post(to: NotificationCenter.default)
    }
}

extension NotificationProtocol {
    
    public func post() {
        
        post(to: NotificationCenter.default)
    }
}
#endif

extension Notification {
    
    public func post(to notificationCenter: NotificationCenter) {
        
        notificationCenter.post(self)
    }
}

extension NotificationProtocol {
    
    public func post(to notificationCenter: NotificationCenter) {
        
        notificationCenter.post(rawNotification)
    }
}
