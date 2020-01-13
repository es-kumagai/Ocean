//
//  UUID.swift
//  ESSwim
//
//  Created by 熊谷 友宏 on H26/12/25.
//
//

import Foundation
import Swim

public struct UUID {

    public static let Null = UUID(null: ())
    
    private var _value: UUIDValue
    private var _isNull: Bool
    
    public init() {
        
        guard let value = UUID._allocate(UUID.RandomAllocator) else {
            
            fatalError("Failed to allocate UUID.")
        }
        
        self.init(value: value)
    }
    
    public init?(string: String) {
        
        guard let value = UUID.toValue(string) else {
            
            return nil
        }
            
        self.init(value: value)
    }
        
    public init(null: ()) {
        
        _value = UUID._allocate(UUID.NullAllocator)!
        _isNull = UUID._isNull(self._value.p)
    }

    public var isNull: Bool {
        
        return self._isNull
    }
}

extension UUID {
    
    public var string: String {
        
        let string = UUIDStringPointer.allocate(capacity: UUID.StringLength + 1)
        
        uuid_unparse_upper(self._value.p, string)
        
        return String(cString: string)
    }
}

// MARK: - Private Features
private extension UUID {
    
    // コピーコンストラクターのようなものがなく、UnsafeMutablePointer で値をそのまま保持しておくのは不安なため、クラスをひとつ噛ませて使います。
    class UUIDValue {
        
        var p: UUIDValueImmutablePointer
        
        init(_ p: UUIDValueImmutablePointer) {
            
            self.p = p
        }
    }
    
    typealias UUIDValuePointer = UnsafeMutablePointer<UInt8>
    typealias UUIDValueImmutablePointer = UnsafePointer<UInt8>
    typealias UUIDStringPointer = UnsafeMutablePointer<Int8>
    
    typealias UUIDAllocator = (UUIDValuePointer) -> ProcessExitStatus
}

private extension UUID {

    private init(value: UUIDValue) {
        
        _value = value
        _isNull = UUID._isNull(self._value.p)
    }
    
    private var rawValue: UUIDValueImmutablePointer {
        
        return self._value.p
    }
}

private extension UUID {
    
    static let ByteLength = 16
    static let StringLength = 36
    
    static let RandomAllocator: UUIDAllocator = {
        
        uuid_generate($0)
        return ProcessExitStatus.passed
    }
    
    static let ParseStringAllocator: ([CChar]) -> UUIDAllocator = { cstring in {
        
        ProcessExitStatus(code: uuid_parse(cstring, $0))
        }
    }
    
    static let NullAllocator: UUIDAllocator = {
        
        uuid_clear($0)
        return ProcessExitStatus.passed
    }
}
    
private extension UUID {

    static func _allocate(_ allocator: UUIDAllocator) -> UUIDValue? {
        
        let pointer = UUIDValuePointer.allocate(capacity: ByteLength)
        
        guard allocator(pointer).passed else {
            
            return nil
        }

        return UUIDValue(pointer)
    }
    
    static func _isNull(_ value: UUIDValueImmutablePointer) -> Bool {
        
        uuid_is_null(value).meansProcessPassed
    }
    
    static func toValue(_ string: String) -> UUIDValue? {
        
        guard let cstring = UUID.toCString(string) else {
            
            return nil
        }

        return UUID._allocate(UUID.ParseStringAllocator(cstring))
    }
    
    static func toCString(_ string: String) -> [CChar]? {
        
        return string.cString(using: .ascii)
    }
}

// MARK: - Printable
extension UUID : CustomStringConvertible {
    
    public var description: String {
        
        string
    }
}

// MARK: - Literal Convertible
extension UUID : ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {

        self.init(null:())
    }
}

extension UUID : ExpressibleByStringLiteral {

    public init(stringLiteral string: String) {

        self.init(value: UUID.toValue(string)!)
    }
}

// MARK: - Comparable
extension UUID : Comparable {
    
    public static func == (lhs: UUID, rhs: UUID) -> Bool {
        
        uuid_compare(lhs.rawValue, rhs.rawValue).meansOrderedSame
    }
    
    public static func > (lhs: UUID, rhs: UUID) -> Bool {
        
        uuid_compare(lhs.rawValue, rhs.rawValue).meansOrderedDescending
    }
    
    public static func < (lhs:UUID, rhs:UUID) -> Bool {
        
        uuid_compare(lhs.rawValue, rhs.rawValue).meansOrderedAscending
    }
    
    public static func >= (lhs:UUID, rhs:UUID) -> Bool {
        
        uuid_compare(lhs.rawValue, rhs.rawValue).meansOrderedDescendingOrSame
    }
    
    public static func <= (lhs:UUID, rhs:UUID) -> Bool {
        
        uuid_compare(lhs.rawValue, rhs.rawValue).meansOrderedAscendingOrSame
    }
}

// MARK: - String Extension

extension String {
    
    public init(_ uuid: UUID) {
        
        self = uuid.string
    }
}
