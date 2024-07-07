//
//  OceanMacro.swift
//
//  
//  Created by Tomohiro Kumagai on 2024/07/07
//  
//

@attached(member, names: named(filter), arbitrary)
public macro URLResourceFilter() = #externalMacro(module: "OceanMacroImplements", type: "URLResourceFilter")
