//
//  File.swift
//  
//  
//  Created by Tomohiro Kumagai on 2023/01/20
//  
//

import Foundation

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
@propertyWrapper
public final class LogFormatted {

    public typealias OnTerminateHandler = () -> Void
    
    fileprivate typealias Task = _Concurrency.Task<Void, Never>
    
    static var notificationCenter = NotificationCenter.default

    let process = Process()
    var targetPipes = [Pipe]()

    private var readingTasks: [Task] = []
    private var terminationTask: Task!
    
    public init(_ target: Target? = .both) {
        
        terminationTask = Task(operation: terminationOperation)

        switch target {
            
        case .none:
            break
            
        case .both:
            process.standardOutput = makeTargetPipe(with: .standardOutput)
            process.standardError = makeTargetPipe(with: .standardError)
            
        case .output:
            process.standardOutput = makeTargetPipe(with: .standardOutput)

        case .error:
            process.standardError = makeTargetPipe(with: .standardError)
        }
    }
    
    public var wrappedValue: Process {
        process
    }
    
    public var projectedValue: LogFormatted {
        self
    }
    
    public var onTerminate: OnTerminateHandler?

}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension Sequence<LogFormatted.Task> {
    func cancel() async {
        
        await withTaskGroup(of: Void.self) { group in

            forEach { task in
                group.addTask {
                    task.cancel()
                    await task.value
                }
            }
            
            await group.waitForAll()
        }
    }
}

private extension Notification {

    var dataItem: Data? {
        userInfo?[NSFileHandleNotificationDataItem] as? Data
    }
    
    var stringItem: String? {
        dataItem.flatMap { String(data: $0, encoding: .utf8) }
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension LogFormatted {
    
    public enum Target {
        case both
        case output
        case error
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private extension LogFormatted {
    func makeTargetPipe(with outputHandle: FileHandle) -> Pipe {

        let pipe = Pipe()
        let task = Task {
            await redirect(from: pipe.fileHandleForReading, to: outputHandle)
        }

        targetPipes.append(pipe)
        readingTasks.append(task)

        pipe.fileHandleForReading.readInBackgroundAndNotify()

        return pipe
    }
    
    static let outputDateFormatter: DateFormatter = {
    
        let formatter = DateFormatter()
        
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        
        return formatter
    }()

    func output(_ message: String, to outputHandle: FileHandle) {
        
        guard !message.isEmpty else {
            return
        }
        
        var stream = FileHandleOutputStream(handle: outputHandle, encoding: .utf8)
        
        let date = Self.outputDateFormatter.string(from: .now)
        let processInfo = ProcessInfo.processInfo
        let processName = processInfo.processName
        let processID = processInfo.processIdentifier
        
        var threadID = 0 as UInt64
        pthread_threadid_np(pthread_self(), &threadID)
        
        print(date, "\(processName)[\(processID):\(threadID)]", message, separator: " ", to: &stream)
    }
    
    @Sendable
    func terminationOperation() async {

        for await _ in Self.notificationCenter.notifications(named: Process.didTerminateNotification, object: process) {
            break
        }
        
        await readingTasks.cancel()
        onTerminate?()
    }
    
    func redirect(from inputHandle: FileHandle, to outputHandle: FileHandle) async {
        
        var buffer = ""

        for await notification in Self.notificationCenter.notifications(named: FileHandle.readCompletionNotification, object: inputHandle) {

            guard let message = notification.stringItem else {
                fatalError("Data which read from file handle of '\(inputHandle)' is not a string.")
            }

            let lines = message
                .split(separator: "\n", omittingEmptySubsequences: false)
                .enumerated()
                .map { offset, line in offset == 0 ? buffer + line : String(line) }

            lines.dropLast().forEach {
                output($0, to: outputHandle)
            }
            
            buffer = lines.last ?? ""
        }
        
        output(buffer, to: outputHandle)
    }
}
