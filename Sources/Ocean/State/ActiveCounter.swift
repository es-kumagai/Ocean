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

    public init() {
    }
    
	public var activeCount: Int {
		
		_invoke {

			self._activeCount(withReport: false)
		}
	}
	
	public var isActive: Bool {
	
		_invoke {
			
			self._isActive(withReport: true)
		}
	}
	
	public func incrementActiveCount(requestOwner owner: AnyObject) -> Int {
		
		_invoke { () -> Int in
			
            self._incrementActiveCount(requestOwner: owner)
			
			return self._activeCount(withReport: false)
		}
	}
	
	public func decrementActiveCount(requestOwner owner: AnyObject) -> Int {
		
		_invoke { () -> Int in
			
            self._decrementActiveCount(requestOwner: owner)

			return self._activeCount(withReport: false)
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
	
	internal func _postActivityReport() {
		
		let notification = ESActiveCounterReportNotification(sender: self)
		
        DispatchQueue.main.async {

			notification.post()
		}
	}

	internal func _activeCount(withReport postReport: Bool) -> Int {
		
		let count = _table.count
		
		if postReport {
			
			_postActivityReport()
		}
		
		return count
	}
	
	internal func _isActive(withReport postReport: Bool) -> Bool {
		
		let isActive = _table.count > 0
		
		if postReport {
			
			_postActivityReport()
		}
		
		return isActive
	}

	internal func _incrementActiveCount(requestOwner: AnyObject) -> Void {
		
		_table.appendLast(requestOwner)
			
		if _table.count == 1 {
				
			_postActivityReport()
		}
	}
	
	internal func _decrementActiveCount(requestOwner: AnyObject) {
		
		_table.removeOneFromFirst(requestOwner)
		
		if _table.count == 0 {
			
			_postActivityReport()
		}
	}
}
