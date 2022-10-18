//
//  NotificationToken.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 12/12/17.
//

import Foundation

extension Notification {
    
    public final class Token : Equatable {
        
        private var rawToken: Any?
        private unowned let notificationCenter: NotificationCenter
        
        internal init(_ rawToken: Any, on notificationCenter: NotificationCenter) {
            
            self.rawToken = rawToken
            self.notificationCenter = notificationCenter
        }
        
        deinit {

            release()
        }
        
        public func release() {

            guard let rawToken else {
                
                return
            }
            
            notificationCenter.removeObserver(rawToken)
            
            self.rawToken = nil
        }
        
        public static func == (lhs: Token, rhs: Token) -> Bool {
            
            lhs === rhs
        }
    }
}

