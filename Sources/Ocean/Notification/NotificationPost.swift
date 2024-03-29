//
//  NotificationPost.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 12/12/17.
//

import Foundation

extension Notification {
    
    public func post(to notificationCenter: NotificationCenter = .default) {
        
        notificationCenter.post(self)
    }
}

extension NotificationProtocol {
    
    public func post(to notificationCenter: NotificationCenter = .default) {
        
        notificationCenter.post(rawNotification)
    }
}
