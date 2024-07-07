//
//  OceanMacroImplements.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/07/07
//  
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct OceanMacroImplementsPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        URLResourceFilter.self,
    ]
}
