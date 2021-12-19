//
//  NotificationHandlers.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 12/12/17.
//

import Foundation

extension Notification {
    
    public final class Handlers {
        
        private var tokens: [Token]
        
        public init() {
            
            self.tokens = []
        }
        
        internal init(tokens: [Token]) {
            
            self.tokens = tokens
        }
        
        public func releaseAll() {
        
            tokens.removeAll()
        }
        
        internal func add(_ token: Token) {
            
            tokens.append(token)
        }
        
        internal func release(_ token: Token) {
            
            if let index = tokens.firstIndex(of: token) {
                
                tokens.remove(at: index)
            }
        }
    }
}
