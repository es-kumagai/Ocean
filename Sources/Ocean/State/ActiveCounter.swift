//
//  ActiveCounter.swift
//  ESActiveCounter
//
//  Created by Tomohiro Kumagai on H27/08/01.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Foundation
import Swim

public final class ActiveCounter {

	var _table =  WeakMultiSet<AnyObject>()
    var _tableManageThread = DispatchQueue(label: "jp.ez-style.thread.active-counter-management")
    
    var reporting: ReportingState

    public init(reporting: ReportingState = .none) {
        
        self.reporting = reporting
    }
    
	public var activeCount: Int {
		
		_invoke {

            self._activeCount(withReport: .none)
		}
	}
	
	public var isActive: Bool {
	
		_invoke {
			
			self._isActive(withReport: reporting)
		}
	}
	
	public func incrementActiveCount(requestOwner owner: AnyObject) -> Int {
		
		_invoke { () -> Int in
			
            self._incrementActiveCount(requestOwner: owner)
			
            return self._activeCount(withReport: .none)
		}
	}
	
	public func decrementActiveCount(requestOwner owner: AnyObject) -> Int {
		
		_invoke { () -> Int in
			
            self._decrementActiveCount(requestOwner: owner)

            return self._activeCount(withReport: .none)
		}
	}

	public func incrementActiveCountAsync(requestOwner owner: AnyObject) {
		
		_invokeAsync { () -> Void in
			
            self._incrementActiveCount(requestOwner: owner)
		}
	}
	
	public func decrementActiveCountAsync(requestOwner owner:AnyObject) {
		
		_invokeAsync { () -> Void in

            self._decrementActiveCount(requestOwner: owner)
		}
	}
	
	public func reset() {
		
		_invokeAsync { () -> Void in
			
			self._reset()
		}
	}
}

extension ActiveCounter {

	internal func _invoke<Result>(predicate: ()->Result) -> Result {
		
        _tableManageThread.sync(execute: predicate)
	}
	
	internal func _invokeAsync(predicate: @escaping ()->Void) {

        _tableManageThread.async(execute: predicate)
	}
	
	internal func _reset() {
	
		_table.removeAll()
	}
	
    internal func _postActivityReport(to notificationCenter: NotificationCenter) {
		
		let notification = ESActiveCounterReportNotification(sender: self)
		
        DispatchQueue.main.async {

			notification.post(to: notificationCenter)
		}
	}

	internal func _activeCount(withReport postReport: ReportingState) -> Int {
		
		let count = _table.count
		
        if case .to(let notificationCenter) = postReport {
			
			_postActivityReport(to: notificationCenter)
		}
		
		return count
	}
	
	internal func _isActive(withReport postReport: ReportingState) -> Bool {
		
		let isActive = _table.count > 0
		
        if case .to(let notificationCenter) = postReport {
			
            _postActivityReport(to: notificationCenter)
		}
		
		return isActive
	}

	internal func _incrementActiveCount(requestOwner: AnyObject) -> Void {
		
		_table.appendLast(requestOwner)
			
        if _table.count == 1, case let .to(notificationCenter) = reporting {
				
            _postActivityReport(to: notificationCenter)
		}
	}
	
	internal func _decrementActiveCount(requestOwner: AnyObject) {
		
		_table.removeOneFromFirst(requestOwner)
		
        if _table.count == 0, case let .to(notificationCenter) = reporting {
			
			_postActivityReport(to: notificationCenter)
		}
	}
}
