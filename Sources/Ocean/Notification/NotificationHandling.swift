//
//  NotificationHandling.swift
//  
//
//  Created by Tomohiro Kumagai on 2021/12/20.
//

import Foundation

@resultBuilder
public enum NotificationHandling {
    
    public static func buildBlock(_ tokens: Notification.Token...) -> Array<Notification.Token> {
        
        tokens
    }
    
    public static func buildFinalResult(_ tokens: Array<Notification.Token>) -> Notification.Handlers {
        
        Notification.Handlers(tokens: tokens)
    }
}
