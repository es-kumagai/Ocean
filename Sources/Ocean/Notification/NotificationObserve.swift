//
//  NotificationObserve.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 12/12/17.
//

import Foundation

public protocol NotificationObservable {

    nonisolated var notificationHandlers: Notification.Handlers { get }
}

public func observe<T: NotificationProtocol>(_ notification: T.Type, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (T) -> Void) -> Notification.Token {

    return _observe(notification, object: object, queue: queue, using: handler)
}

public func observe(notificationNamed name: Notification.Name, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (Notification) -> Void) -> Notification.Token {
    
    return _observe(notificationNamed: name, object: object, queue: queue, using: handler)
}

public func observe<T: NotificationProtocol, Observer: NSObjectProtocol>(_ notification: T.Type, observer: Observer, selector: Selector, object: Any? = nil) -> Notification.Token {
    
    return _observe(notification, observer: observer, selector: selector, object: object)
}


private func _observe<T: NotificationProtocol>(_ notification: T.Type, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (T) -> Void) -> Notification.Token {
    
    return Notification.Token(notificationCenter.addObserver(forName: notification.notificationName, object: object, queue: queue) { rawNotification in
        
        handler(rawNotification.object as! T)
    })
}

private func _observe(notificationNamed name: Notification.Name, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (Notification) -> Void) -> Notification.Token {
    
    return Notification.Token(
        notificationCenter.addObserver(forName: name, object: object, queue: queue, using: handler)
    )
}

private func _observe<T: NotificationProtocol, Observer: NSObjectProtocol>(_ notification: T.Type, observer: Observer, selector: Selector, object: Any? = nil) -> Notification.Token {
    
    return _observe(T.self) { notification in
        
        observer.perform(selector, with: notification)
    }
}

extension NotificationObservable {
    
    public func observe<T: NotificationProtocol, Observer: NSObjectProtocol>(_ notification: T.Type, observer: Observer, selector: Selector, object: Any? = nil) {
        
        notificationHandlers.observe(notification, observer: observer, selector: selector, object: object)
    }
    
    public func observe(notificationNamed name: Notification.Name, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (Notification) -> Void) {
        
        notificationHandlers.observe(notificationNamed: name, object: object, queue: queue, using: handler)
    }
    
    public func observe<T: NotificationProtocol>(_ notification: T.Type, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (T) -> Void) {
        
        notificationHandlers.observe(notification, object: object, queue: queue, using: handler)
    }
    
    public func release(notification token: Notification.Token) {
        
        Task {
            await notificationHandlers.release(token)
        }
    }
}

extension Notification.Handlers {
    
    public nonisolated func observe<T: NotificationProtocol>(_ notification: T.Type, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (T) -> Void) {

        let token = _observe(notification, object: object, queue: queue, using: handler)
        
        Task {
            await add(token)
        }
    }

    public nonisolated func observe(notificationNamed name: Notification.Name, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (Notification) -> Void) {

        let token = _observe(notificationNamed: name, object: object, queue: queue, using: handler)
        
        Task {
            await add(token)
        }
    }

    public nonisolated func observe<T: NotificationProtocol, Observer: NSObjectProtocol>(_ notification: T.Type, observer: Observer, selector: Selector, object: Any? = nil) {
        
        let token = _observe(notification, observer: observer, selector: selector, object: object)
        
        Task {
            await add(token)
        }
    }
}
