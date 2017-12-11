//
//  NotificationToken.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 12/12/17.
//

import Foundation

extension Notification {
    
    public final class Token : Equatable {
        
        private var token: Any
        
        internal init(_ token: Any) {
            
            self.token = token
        }
        
        deinit {
            
            notificationCenter.removeObserver(token)
        }
        
        public static func == (lhs: Token, rhs: Token) -> Bool {
            
            return lhs === rhs
        }
    }
}

