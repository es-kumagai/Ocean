//
//  NotificationToken.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 12/12/17.
//

import Foundation

extension Notification {
    
    public final class Token : Equatable {
        
        private var token: Any?
        private unowned let notificationCenter: NotificationCenter
        
        internal init(_ token: Any, on notificationCenter: NotificationCenter) {
            
            self.token = token
            self.notificationCenter = notificationCenter
        }
        
        deinit {

            release()
        }
        
        public func release() {

            guard let t = token else {
                
                return
            }
            
            notificationCenter.removeObserver(t)
            token = nil
        }
        
        public static func == (lhs: Token, rhs: Token) -> Bool {
            
            lhs === rhs
        }
    }
}

