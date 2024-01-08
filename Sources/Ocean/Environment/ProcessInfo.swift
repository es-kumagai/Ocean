//
//  URL.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/01/08
//  
//

import Foundation
import RegexBuilder

public extension ProcessInfo {
    
    /// Resolving environment variables in `string`.
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
    
    /// Resolving environment variables in `string`.
    /// - Parameter string: A string to resolve environment variables.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A string that resolved environment variables.
    func resolvingEnvironmentVariables(in string: some StringProtocol, replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) -> String {
        
        var string = String(string)
        resolveEnvironmentVariables(in: &string, replacingStringIfNotExistsInEnvironment: alternativeText)
        
        return string
    }
}

public extension StringProtocol {
    
    /// Expand environment variables in this string.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) {
        ProcessInfo.processInfo.resolveEnvironmentVariables(in: &self, replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// Returns a string expanded environment variables in.
    var expandedEnvironmentVariables: String {
        expandedEnvironmentVariables()
    }
    
    /// Returns a string expanded environment variables in.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) -> String {
        ProcessInfo.processInfo.resolvingEnvironmentVariables(in: self, replacingStringIfNotExistsInEnvironment: alternativeText)
    }
}

public extension BinaryInteger {
    
    /// Expand environment variables in this value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) throws {
        self = try expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// Returns a value expanded environment variables in this value.
    var expandedEnvironmentVariables: Self {
        get throws {
            try expandedEnvironmentVariables()
        }
    }
    
    /// Returns a value expanded environment variables in this value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A value expanded environment variables in this value.
    func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) throws -> Self {
        
        let stringValue = String(describing: self).expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        let numericValue = try Self(stringValue, format: IntegerFormatStyle<Self>())
        
        return numericValue
    }
}

public extension BinaryFloatingPoint {
    
    /// Expand environment variables in this value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) throws {
        self = try expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// Returns a value expanded environment variables in this value.
    var expandedEnvironmentVariables: Self {
        get throws {
            try expandedEnvironmentVariables()
        }
    }
    
    /// Returns a value expanded environment variables in this value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A value expanded environment variables in this value.
    func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) throws -> Self {
        
        let stringValue = String(describing: self).expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        let numericValue = try Self(stringValue, format: FloatingPointFormatStyle<Self>())

        return numericValue
    }
}

public extension URLQueryItem {
    
    /// Expand environment variables in the name.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) {
        name.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// Expand environment variables in the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) {
        value?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// Expand environment variables in both the name and the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) {
        expandEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment: alternativeText)
        expandEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment: alternativeText)
    }
    
    /// Returns a query item expanded environment variables in the name.
    var expandedEnvironmentVariablesInName: URLQueryItem {
        expandedEnvironmentVariablesInName()
    }
    
    /// Returns a query item expanded environment variables in the name.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in the name.
    func expandedEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) -> URLQueryItem {
        URLQueryItem(
            name: name.expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText),
            value: value
        )
    }
    
    /// Returns a query item expanded environment variables in the value.
    var expandedEnvironmentVariablesInValue: URLQueryItem {
        expandedEnvironmentVariablesInValue()
    }
    
    /// Returns a query item expanded environment variables in the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in the value.
    func expandedEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) -> URLQueryItem {
        URLQueryItem(
            name: name,
            value: value?.expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        )
    }
    
    /// Returns a query item expanded environment variables in both the name and the value.
    var expandedEnvironmentVariables: URLQueryItem {
        expandedEnvironmentVariables()
    }
    
    /// Returns a query item expanded environment variables in both the name and the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in both the name and the value.
    func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) -> URLQueryItem {
        URLQueryItem(
            name: name.expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText),
            value: value?.expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        )
    }
}

public extension MutableCollection<StringProtocol> {
    
    /// Expand environment variables in each element.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) {

        for index in indices {
            self[index].expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
}

public extension MutableCollection<URLQueryItem> {
    
    /// Expand environment variables in the name.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) {
        
        for index in indices {
            self[index].name.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
    
    /// Expand environment variables in the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) {
        
        for index in indices {
            self[index].value?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
    
    /// Expand environment variables in both the name and the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    mutating func expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) {
        
        for index in indices {
            self[index].name.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
            self[index].value?.expandEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
}
 
extension Sequence<URLQueryItem> {

    /// Returns a query item expanded environment variables in the name.
    var expandedEnvironmentVariablesInName: [URLQueryItem] {
        expandedEnvironmentVariablesInName()
    }
    
    /// Returns a query item expanded environment variables in the name.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in the name.
    func expandedEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) -> [URLQueryItem] {
        
        map { item in
            item.expandedEnvironmentVariablesInName(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
    
    /// Returns a query item expanded environment variables in the value.
    var expandedEnvironmentVariablesInValue: [URLQueryItem] {
        expandedEnvironmentVariablesInValue()
    }
    
    /// Returns a query item expanded environment variables in the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in the value.
    func expandedEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) -> [URLQueryItem] {
        
        map { item in
            item.expandedEnvironmentVariablesInValue(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
    
    /// Returns a query item expanded environment variables in both the name and the value.
    var expandedEnvironmentVariables: [URLQueryItem] {
        expandedEnvironmentVariables()
    }
    
    /// Returns a query item expanded environment variables in both the name and the value.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: A query item expanded environment variables in both the name and the value.
    func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) -> [URLQueryItem] {
        
        map { item in
            item.expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment: alternativeText)
        }
    }
}

public extension URL {

    /// The URL that expanded environment variables in the path.
    var expandedEnvironmentVariables: URL? {

        expandedEnvironmentVariables()
    }
    
    /// The URL that expanded environment variables in the url.
    /// - Parameter replacingStringIfNotExistsInEnvironment: A string to replace if the environment variable does not exist.
    /// - Returns: The URL that expanded environment variables in the url.
    func expandedEnvironmentVariables(replacingStringIfNotExistsInEnvironment alternativeText: String? = nil) -> URL? {
        
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
    
    /// Regex pattern for environment variable name.
    static let environmentNamePattern = Regex {
        One(.word)
        ZeroOrMore {
            CharacterClass(
                .word,
                .digit
            )
        }
    }
    
    /// Regex pattern for environment variable.
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
