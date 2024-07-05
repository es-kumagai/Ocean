//
//  Logger.swift
//  Ocean
//  
//  Created by Tomohiro Kumagai on 2024/06/04
//  
//

import os

public protocol LogOutputInterjectable {
    
}

public extension LogOutputInterjectable {

    consuming func interjectLog(_ message: some StringProtocol) -> Self {

        print(message)
        return self
    }

    consuming func interjectLog(by logger: Logger, predicate: (Logger) -> Void) -> Self {

        predicate(logger)
        return self
    }

    consuming func interjectLog(by logger: Logger, level: OSLogType, message: String) -> Self {

        interjectLog(by: logger) {
            $0.log(level: level, "\(message)")
        }
    }
    
    consuming func interjectLog(by logger: Logger, message: String) -> Self {

        logger.log("\(message)")
        return self
    }
    
    consuming func interjectWarningLog(by logger: Logger, _ message: String) -> Self {
        
        logger.warning("\(message)")
        return self
    }

    consuming func interjectErrorLog(by logger: Logger, message: String) -> Self {

        logger.error("\(message)")
        return self
    }

    consuming func interjectInfoLog(by logger: Logger, message: String) -> Self {
        
        logger.info("\(message)")
        return self
    }

    consuming func interjectNoticeLog(by logger: Logger, message: String) -> Self {

        logger.notice("\(message)")
        return self
    }

    consuming func interjectDebugLog(by logger: Logger, message: String) -> Self {

        logger.debug("\(message)")
        return self
    }
    
    consuming func interjectTraceLog(by logger: Logger, message: String) -> Self {

        logger.trace("\(message)")
        return self
    }

    consuming func interjectCriticalLog(by logger: Logger, message: String) -> Self {

        logger.critical("\(message)")
        return self
    }

    consuming func interjectFaultLog(by logger: Logger, message: String) -> Self {

        logger.fault("\(message)")
        return self
    }
}
