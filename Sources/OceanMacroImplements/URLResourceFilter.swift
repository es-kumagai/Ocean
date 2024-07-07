//
//  URLResourceFilter.swift
//
//
//  Created by Tomohiro Kumagai on 2024/07/07
//
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import Earth
import EarthMacroCrust

public struct URLResourceFilter : MemberMacro {
    
    static let filterNodeName = "URLResourceFilter"
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        guard let filterNode = declaration.memberBlock.enumerations.named(filterNodeName).first else {
            
            throw MacroError.notSufficientDefinition("Enumeration named '\(filterNodeName)' is not defined.", node: declaration)
        }
        
        let specificFilters: [DeclSyntax] = try filterNode
            .allCaseElements
            .flatMap(makeFilters(for:))
        
        return basicFilters + specificFilters
    }
}

private extension URLResourceFilter {
    
    static let equatableTypes = [
        "Date",
        "Int",
        "Int8",
        "Int16",
        "Int32",
        "Int64",
        "UInt8",
        "UInt16",
        "UInt32",
        "UInt64",
        "Float",
        "Double",
        "UTType",
        "URLFileResourceType",
        "URLFileProtection",
        "URLUbiquitousItemDownloadingStatus",
        "URLUbiquitousSharedItemRole",
        "URLUbiquitousSharedItemPermissions",
        "PersonNameComponents",
    ]
    
    static let basicFilters: [DeclSyntax] = [
        """
        func filter<Value>(by key: URLResourceKey, resourcePath path: KeyPath<URLResourceValues, Value?>, compare: (_ valueInResource: Value) throws -> Bool) throws -> [URL] {
            
            try filter { url in
                
                guard let value = try url.resourceValues(forKeys: [key])[keyPath: path] else {
                    throw URLResourceError.resourceNotFound(key)
                }
                
                return try compare(value)
            }
        }
        """,
        """
        func filter<Value>(by key: URLResourceKey, resourcePath path: KeyPath<URLResourceValues, Value?>, value specifiedValue: Value) throws -> [URL] where Value : Equatable {
            
            try filter(by: key, resourcePath: path) { valueInResource in
                valueInResource == specifiedValue
            }
        }
        """,
        """
        func filter(by key: URLResourceKey, resourcePath path: KeyPath<URLResourceValues, String?>, value specifiedValue: some StringProtocol) throws -> [URL] {
            
            try filter(by: key, resourcePath: path) { valueInResource in
                valueInResource == specifiedValue
            }
        }
        """,
        """
        func filter(by key: URLResourceKey, resourcePath path: KeyPath<URLResourceValues, String?>, value specifiedValue: String) throws -> [URL] {
            
            try filter(by: key, resourcePath: path) { valueInResource in
                valueInResource == specifiedValue
            }
        }
        """,
        """
        func filter(by key: URLResourceKey, resourcePath path: KeyPath<URLResourceValues, [String]?>, value: some Sequence<some StringProtocol>) throws -> [URL] {
            try filter(by: key, resourcePath: path) { valueInResource in
                value.lazy.map(String.init(_:)) == valueInResource
            }
        }
        """,
        """
        func filter(by key: URLResourceKey, resourcePath path: KeyPath<URLResourceValues, Bool?>) throws -> [URL] {
            try filter(by: key, resourcePath: path, value: true)
        }
        """,
        """
        func filter(by key: URLResourceKey, resourcePath path: KeyPath<URLResourceValues, String?>, value: some FilePathConvertible) throws -> [URL] {
            try filter(by: key, resourcePath: path, value: value.filePathDescription)
        }
        """,
        """
        func filter(by key: URLResourceKey, resourcePath path: KeyPath<URLResourceValues, URL?>, value: some FilePathConvertible) throws -> [URL] {
            try filter(by: key, resourcePath: path) { valueInResource in
                valueInResource.filePathDescription == value.filePathDescription
            }
        }
        """
    ]
    
    final class ParameterNamesDescriptionFormatter : ListFormatter {
        
        override init() {
            
            super.init()
            
            locale = Locale(identifier: "en_US_POSIX")
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }
    
    struct MakingOption {
        
        var basename: String? = nil
        var key: String? = nil
        var path: String? = nil
        var available: [String] = []
        
        static let expectingSingleParameters: [String : WritableKeyPath<Self, String?>] = [

            "basename" : \.basename,
            "key" : \.key,
            "path" : \.path
        ]
        
        static let expectingListParameters: [String : WritableKeyPath<Self, [String]>] = [

            "available" : \.available
        ]

        static let formatter = ParameterNamesDescriptionFormatter()
        
        static var expectingParametersDescription: String {
            
            let keys = expectingSingleParameters.keys.map { "`\($0)`" } + expectingListParameters.keys.map { "`\($0)`" }
            
            return formatter.string(from: keys)!
        }
        
        init(from parameters: some Sequence<EnumCaseParameterSyntax>, at node: some SyntaxProtocol) throws {
            
            for parameter in parameters {
                
                guard let labelName = parameter.firstName?.text else {
                    throw MacroError.invalidParameter("Option parameters must have label names.", node: node)
                }
                
                if let targetKeyPath = Self.expectingSingleParameters[labelName] {
                    
                    guard let defaultValue = parameter.defaultValue?.value.as(StringLiteralExprSyntax.self)?.text else {
                        throw MacroError.invalidParameter("The default value of the parameter named `\(labelName)` must be specified using a string literal or an array of string literals.", node: node)
                    }
                    
                    self[keyPath: targetKeyPath] = defaultValue

                    continue
                }
                
                if let targetKeyPath = Self.expectingListParameters[labelName] {
                    
                    if let defaultValue = parameter.defaultValue?.value.as(StringLiteralExprSyntax.self) {
                        
                        self[keyPath: targetKeyPath] = [defaultValue.text]
                        continue
                    }
                    
                    if let defaultValue = try parameter.defaultValue?.value.asArray(of: StringLiteralExprSyntax.self) {

                        self[keyPath: targetKeyPath] = defaultValue.map(\.text)
                        continue
                    }
                    
                    throw MacroError.invalidParameter("The default value of the parameter named `\(labelName)` must be specified using a string literal or an array of string literals.", node: node)
                }
                
                throw MacroError.invalidParameter("The parameter name `\(labelName)` is not expected here. In this context, \(Self.expectingParametersDescription) are allowed as parameter names.", node: node)
            }
        }
        
        func basename(for name: some StringProtocol) -> String {
            basename ?? "filterBy\(name.stringWithUppercasedFirstLetter)"
        }
        
        func key(for name: some StringProtocol) -> String {
            key ?? ".\(name)Key"
        }
        
        func path(for name: some StringProtocol) -> String {
            path ?? #"\.\#(name)"#
        }
        
        func available(for name: some StringProtocol) -> AttributeListSyntax {
            
            AttributeListSyntax {
                for item in available {
                    "@available(\(raw: item))"
                }
            }
        }
    }
    
    static func makeCustomComparationFilter(name: String, type: String, attributes: AttributeListSyntax?, option: MakingOption) -> DeclSyntax {
        
        """
        \(attributes ?? "")
        \(option.available(for: name))
        func \(raw: option.basename(for: name))(_ comparisonPredicate: (_ value: \(raw: type)) -> Bool) throws -> [URL] {
            try filter(by: \(raw: option.key(for: name)), resourcePath: \(raw: option.path(for: name)), compare: comparisonPredicate)
        }
        """
    }
    
    static func makeValueFilter(name: String, type: String, attributes: AttributeListSyntax?, option: MakingOption) -> DeclSyntax {
        
        """
        \(attributes ?? "")
        \(option.available(for: name))
        func \(raw: option.basename(for: name))(_ value: \(raw: type)) throws -> [URL] {
            try filter(by: \(raw: option.key(for: name)), resourcePath: \(raw: option.path(for: name)), value: value)
        }
        """
    }
    
    static func makeConditionFilter(name: String, attributes: AttributeListSyntax?, option: MakingOption) -> DeclSyntax {
        
        """
        \(attributes ?? "")
        \(option.available(for: name))
        func \(raw: option.basename(for: name))() throws -> [URL] {
            try filter(by: \(raw: option.key(for: name)), resourcePath: \(raw: option.path(for: name)))
        }
        """
    }
    
    static func makeFilters(for element: EnumCaseElementSyntax) throws -> [DeclSyntax] {
        
        let targetName = element.name
        let attributes: AttributeListSyntax? = if let caseNode = element.parent?.as(EnumCaseDeclSyntax.self) {
            caseNode.attributes
        } else {
            nil
        }
        
        guard element.parameterCount > 0 else {
            
            throw MacroError.notSufficientDefinition("The enumeration case '\(targetName)' must have at least one parameter.", node: element)
        }
        
        guard element.firstParameter!.firstName == nil else {
            throw MacroError.invalidParameter("The first parameter must have no label.", node: element)
        }
        
        let type = element.firstParameter!.type
        let option = try MakingOption(from: element.parameters!.dropFirst(), at: element)
        
        return switch type.text {
            
        case "String":
            [
                makeValueFilter(name: targetName.text, type: "some StringProtocol", attributes: attributes, option: option),
                makeCustomComparationFilter(name: targetName.text, type: "String", attributes: attributes, option: option)
            ]

        case "[String]", "Array<String>":
            [
                makeValueFilter(name: targetName.text, type: "some Sequence<some StringProtocol>", attributes: attributes, option: option),
                makeCustomComparationFilter(name: targetName.text, type: "[String]", attributes: attributes, option: option)
            ]

        case "Bool":
            [
                makeConditionFilter(name: targetName.text, attributes: attributes, option: option),
                makeValueFilter(name: targetName.text, type: "Bool", attributes: attributes, option: option),
                makeCustomComparationFilter(name: targetName.text, type: "Bool", attributes: attributes, option: option)
            ]
          
        case "FilePathConvertible":
            [
                makeValueFilter(name: targetName.text, type: "some FilePathConvertible", attributes: attributes, option: option),
                makeCustomComparationFilter(name: targetName.text, type: "String", attributes: attributes, option: option)
             ]

        case "URL":
            [
                makeValueFilter(name: targetName.text, type: "some FilePathConvertible", attributes: attributes, option: option),
                makeCustomComparationFilter(name: targetName.text, type: "URL", attributes: attributes, option: option)
             ]

        case let type where equatableTypes.contains(type):
            [
                makeValueFilter(name: targetName.text, type: type, attributes: attributes, option: option),
                makeCustomComparationFilter(name: targetName.text, type: type, attributes: attributes, option: option)
            ]
            
        case let type:
            [
                makeCustomComparationFilter(name: targetName.text, type: type, attributes: attributes, option: option)
            ]
        }
    }
}
