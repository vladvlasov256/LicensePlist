//
//  File.swift
//  
//
//  Created by Vladimir Vlasov on 07/02/2023.
//

import Foundation
import PackagePlugin

@main
struct LicensePlistBuildTool: BuildToolPlugin {
    func createBuildCommands(context: PluginContext,
                             target: Target) async throws -> [Command] {
        let tool = try context.tool(named: "license-plist")        
        return [
            .buildCommand(displayName: "LicensePlist is processing licenses...",
                          executable: tool.path,
                          arguments: [],
                          inputFiles: [],
                          outputFiles: [])
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension LicensePlistBuildTool: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let tool = try context.tool(named: "license-plist")
        return [
            .buildCommand(displayName: "LicensePlist is processing licenses...",
                          executable: tool.path,
                          arguments: [],
                          inputFiles: [],
                          outputFiles: [])
        ]
    }
}

#endif
