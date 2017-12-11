//
//  Observable.swift
//  Ocean
//
//  Created by Tomohiro Kumagai on 12/12/17.
//

import Foundation

public protocol NotificationObservable {

}

public protocol ManagedNotificationObservable : NotificationObservable {

    var notificationHandlers: Notification.Handlers { get }
}

extension NotificationObservable {

    public func observe<T: NotificationProtocol, Observer: NSObjectProtocol>(notification: T.Type, observer: Observer, selector: Selector, object: Any? = nil) -> Notification.Token {

        return observe(notification: T.self) { notification in
            
            observer.perform(selector, with: notification)
        }
    }

    public func observe(notificationName name: Notification.Name, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (Notification) -> Void) -> Notification.Token {

        return Notification.Token(
            notificationCenter.addObserver(forName: name, object: object, queue: queue, using: handler)
        )
    }

    public func observe<T: NotificationProtocol>(notification: T.Type, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (T) -> Void) -> Notification.Token {

        return Notification.Token(notificationCenter.addObserver(forName: notification.notificationName, object: object, queue: queue) { rawNotification in

            handler(rawNotification.object as! T)
        })
    }
}

extension ManagedNotificationObservable {
    
    public func observe<T: NotificationProtocol, Observer: NSObjectProtocol>(notification: T.Type, observer: Observer, selector: Selector, object: Any? = nil) {
        
        notificationHandlers.add(
            observe(notification: notification, observer: observer, selector: selector, object: object)
        )
    }
    
    public func observe(notificationName name: Notification.Name, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (Notification) -> Void) {
        
        notificationHandlers.add(
            observe(notificationName: name, object: object, queue: queue, using: handler)
        )
    }
    
    public func observe<T: NotificationProtocol>(notification: T.Type, object: Any? = nil, queue: OperationQueue? = nil, using handler: @escaping (T) -> Void) {
        
        notificationHandlers.add(
            observe(notification: notification, object: object, queue: queue, using: handler)
        )
    }
    
    public func release(notification token: Notification.Token) {
        
        notificationHandlers.release(token)
    }
}
