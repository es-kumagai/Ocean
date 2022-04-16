//
//  NotificationHandlers.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 12/12/17.
//

import Foundation

extension Notification {
    
    public actor Handlers : Sendable {
        
        private var tokens: [Token]
        
        public init() {
            
            self.tokens = []
        }
        
        internal init(tokens: [Token]) {
            
            self.tokens = tokens
        }
        
        public nonisolated func releaseAll() {
        
            Task {

                await isolatedReleaseAll()
            }
        }
    }
}

internal extension Notification.Handlers {
        
    func isolatedReleaseAll() {
        
        tokens.removeAll()
    }
    
    func add(_ token: Notification.Token) {
        
        tokens.append(token)
    }
    
    func release(_ token: Notification.Token) {
        
        if let index = tokens.firstIndex(of: token) {
            
            tokens.remove(at: index)
        }
    }
}
