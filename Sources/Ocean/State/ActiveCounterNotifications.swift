//
//  Notifications.swift
//  ESActiveCounter
//
//  Created by Tomohiro Kumagai on H27/08/01.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

/// Report the count activity information in irregular timing.
public final class ESActiveCounterReportNotification : NotificationProtocol {
	
	public let isActive: Bool
	public let activeCount: Int
	
	private unowned let source: ActiveCounter
	
	/// The initializer must call in ESActiveCounter._tableManageThread queue.
	internal init(sender: ActiveCounter) {
		
		self.source = sender
		
        isActive = sender._isActive(withReport: .none)
        activeCount = sender._activeCount(withReport: .none)
	}
	
	public func isSameSource(sender: ActiveCounter) -> Bool {
		
		return sender === self.source
	}
}
