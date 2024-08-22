//
//  URL.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/01/08
//  
//

import Foundation
import RegexBuilder

@available(iOS 16.0, *)
public extension ProcessInfo {
    
    /// [Ocean] Resolving environment variables in `string`.
    /// - Parameter string: A string to resolve environment variables.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    func resolveEnvironmentVariables<SomeString>(in string: inout SomeString, replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) where SomeString : StringProtocol {

        var continueResolving: Bool
        var resolvingString = String(string)

        repeat {
            
            continueResolving = false
            
            resolvingString.replace(Self.environmentPattern) { match in
                
                guard let name = match.1 ?? match.2 else {
                    fatalError("No environment variable's name is matched.")
                }
                
                switch environment[String(name)] {
                    
                case let value?:
                    continueResolving = true
                    return value
                    
                case nil:
                    return alternativeText ?? String(match.0)
                }
            }
        } while (continueResolving)
        
        string = SomeString(resolvingString)!
    }
    
    /// [Ocean] Resolving environment variables in `string`.
    /// - Parameter string: A string to resolve environment variables.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A string that resolved environment variables.
    func resolvingEnvironmentVariables(in string: some StringProtocol, replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) -> String {
        
        var string = String(string)
        resolveEnvironmentVariables(in: &string, replacingStringIfNotExistsInEnvironment: alternativeText)
        
        return string
    }
}

@available(iOS 16.0, *)
public extension StringProtocol {
    
    /// [Ocean] Expand environment variables in this string.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) {
        ProcessInfo.processInfo.resolveEnvironmentVariables(in: &self, replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// [Ocean] Returns a string expanded environment variables in.
    var expandedEnvironmentVariables: String {
        
        borrowing get {
            expandedEnvironmentVariables()
        }
    }
    
    /// [Ocean] Returns a string expanded environment variables in.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    borrowing func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) -> String {
        ProcessInfo.processInfo.resolvingEnvironmentVariables(in: self, replacingStringIfNotExistsInEnvironment: alternativeText)
    }
}

@available(iOS 16.0, *)
public extension BinaryInteger {
    
    /// [Ocean] Expand environment variables in this value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) throws {
        self = try expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// [Ocean] Returns a value expanded environment variables in this value.
    var expandedEnvironmentVariables: Self {
        borrowing get throws {
            try expandedEnvironmentVariables()
        }
    }
    
    /// [Ocean] Returns a value expanded environment variables in this value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A value expanded environment variables in this value.
    borrowing func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) throws -> Self {
        
        let stringValue = String(copy self).expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        let numericValue = try Self(stringValue, format: IntegerFormatStyle<Self>())
        
        return numericValue
    }
}

@available(iOS 16.0, *)
public extension BinaryFloatingPoint {
    
    /// [Ocean] Expand environment variables in this value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) throws {
        self = try expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// [Ocean] Returns a value expanded environment variables in this value.
    var expandedEnvironmentVariables: Self {
        borrowing get throws {
            try expandedEnvironmentVariables()
        }
    }
    
    /// [Ocean] Returns a value expanded environment variables in this value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A value expanded environment variables in this value.
    borrowing func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) throws -> Self {
        
        let stringValue = String(describing: copy self).expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        let numericValue = try Self(stringValue, format: FloatingPointFormatStyle<Self>())

        return numericValue
    }
}

@available(iOS 16.0, *)
public extension URLQueryItem {
    
    /// [Ocean] Expand environment variables in the name.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) {
        name.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// [Ocean] Expand environment variables in the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) {
        value?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// [Ocean] Expand environment variables in both the name and the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) {
        expandEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment: alternativeText)
        expandEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// [Ocean] Returns a query item expanded environment variables in the name.
    var expandedEnvironmentVariablesInName: URLQueryItem {
        borrowing get {
            expandedEnvironmentVariablesInName()
        }
    }
    
    /// [Ocean] Returns a query item expanded environment variables in the name.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in the name.
    func expandedEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) -> URLQueryItem {
        URLQueryItem(
            name: name.expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText),
            value: value
        )
    }
    
    /// [Ocean] Returns a query item expanded environment variables in the value.
    var expandedEnvironmentVariablesInValue: URLQueryItem {
        borrowing get {
            expandedEnvironmentVariablesInValue()
        }
    }
    
    /// [Ocean] Returns a query item expanded environment variables in the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in the value.
    func expandedEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) -> URLQueryItem {
        URLQueryItem(
            name: name,
            value: value?.expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        )
    }
    
    /// [Ocean] Returns a query item expanded environment variables in both the name and the value.
    var expandedEnvironmentVariables: URLQueryItem {
        borrowing get {
            expandedEnvironmentVariables()
        }
    }
    
    /// [Ocean] Returns a query item expanded environment variables in both the name and the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in both the name and the value.
    func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) -> URLQueryItem {
        URLQueryItem(
            name: name.expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText),
            value: value?.expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        )
    }
}

@available(iOS 16.0, *)
public extension MutableCollection<StringProtocol> {
    
    /// [Ocean] Expand environment variables in each element.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) {

        for index in indices {
            self[index].expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
}

@available(iOS 16.0, *)
public extension MutableCollection<URLQueryItem> {
    
    /// [Ocean] Expand environment variables in the name.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) {
        
        for index in indices {
            self[index].name.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
    
    /// [Ocean] Expand environment variables in the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) {
        
        for index in indices {
            self[index].value?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
    
    /// [Ocean] Expand environment variables in both the name and the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) {
        
        for index in indices {
            self[index].name.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
            self[index].value?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
}
 
@available(iOS 16.0, *)
extension Sequence<URLQueryItem> {

    /// [Ocean] Returns a query item expanded environment variables in the name.
    var expandedEnvironmentVariablesInName: [URLQueryItem] {
        borrowing get {
            expandedEnvironmentVariablesInName()
        }
    }
    
    /// [Ocean] Returns a query item expanded environment variables in the name.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in the name.
    borrowing func expandedEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) -> [URLQueryItem] {
        
        map { item in
            item.expandedEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
    
    /// [Ocean] Returns a query item expanded environment variables in the value.
    var expandedEnvironmentVariablesInValue: [URLQueryItem] {
        borrowing get {
            expandedEnvironmentVariablesInValue()
        }
    }
    
    /// [Ocean] Returns a query item expanded environment variables in the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in the value.
    borrowing func expandedEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) -> [URLQueryItem] {
        
        map { item in
            item.expandedEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
    
    /// [Ocean] Returns a query item expanded environment variables in both the name and the value.
    var expandedEnvironmentVariables: [URLQueryItem] {
        borrowing get {
            expandedEnvironmentVariables()
        }
    }
    
    /// [Ocean] Returns a query item expanded environment variables in both the name and the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in both the name and the value.
    borrowing func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) -> [URLQueryItem] {
        
        map { item in
            item.expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
}

@available(iOS 16.0, *)
public extension URL {

    /// [Ocean] The URL that expanded environment variables in the path.
    var expandedEnvironmentVariables: URL? {
        borrowing get {
            expandedEnvironmentVariables()
        }
    }
    
    /// [Ocean] The URL that expanded environment variables in the url.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: The URL that expanded environment variables in the url.
    borrowing func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: borrowing String? = nil) -> URL? {
        
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            
            return nil
        }
        
        components.scheme?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        components.host?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        try! components.port?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        components.path.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        components.query?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        components.user?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        components.fragment?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        
        return components.url
    }
}

private extension ProcessInfo {
    
    /// [Ocean] Regex pattern for environment variable name.
    @available(iOS 16.0, *)
    static let environmentNamePattern = Regex {
        One(.word)
        ZeroOrMore {
            CharacterClass(
                .word,
                .digit
            )
        }
    }
    
    /// [Ocean] Regex pattern for environment variable.
    @available(iOS 16.0, *)
    static let environmentPattern = Regex {
        "$"
        ChoiceOf {
            Regex {
                "{"
                Capture {
                    environmentNamePattern
                }
                "}"
            }
            Regex {
                Capture {
                    environmentNamePattern
                }
                Anchor.wordBoundary
            }
        }
    }
}
