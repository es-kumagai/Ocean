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
        
        internal init(_ token: Any) {
            
            self.token = token
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
            
            return lhs === rhs
        }
    }
}

