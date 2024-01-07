//
//  URL.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/01/08
//  
//

import Foundation
import RegexBuilder

public extension URL {
    
    /// The URL that expanded environment variables in the path.
    var expandedEnvironmentVariables: URL? {

        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            
            return nil
        }
        
        let environment = ProcessInfo.processInfo.environment
        
        components.path.replace(Self.environmentPattern) { match in

            let name = String(match.1 ?? match.2 ?? "")
            
            return switch environment[name] {
                
            case let value?:
                value
                
            default:
                String(match.0)
            }
        }
        
        return components.url
    }
}

private extension URL {
    
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
