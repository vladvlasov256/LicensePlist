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
        let tool = try context.tool(named: "LicensePlist")
        return [
            .prebuildCommand(displayName: "LicensePlist is processing licenses...",
                             executable: tool.path,
                             arguments: [],
                             outputFilesDirectory: context.pluginWorkDirectory)
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension LicensePlistBuildTool: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let tool = try context.tool(named: "LicensePlist")
        return [
            .prebuildCommand(displayName: "LicensePlist is processing licenses...",
                             executable: tool.path,
                             arguments: [],
                             outputFilesDirectory: context.pluginWorkDirectory)
        ]
    }
}

#endif
