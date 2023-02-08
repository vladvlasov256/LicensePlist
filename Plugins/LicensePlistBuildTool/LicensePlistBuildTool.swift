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
        
        let resourcesDirectoryPath = context.pluginWorkDirectory
            .appending(subpath: target.displayName)
            .appending(subpath: "Resources")
        
        try FileManager.default.createDirectory(atPath: resourcesDirectoryPath.string, withIntermediateDirectories: true)
        
        let plistPath = resourcesDirectoryPath.appending(subpath: "Acknowledgements.plist")
        let latestResultPath = resourcesDirectoryPath.appending(subpath: "Acknowledgements.latest_result")
        
        return [
            .buildCommand(displayName: "LicensePlist is processing licenses...",
                          executable: tool.path,
                          arguments: ["--output-path", resourcesDirectoryPath],
                          outputFiles: [plistPath, latestResultPath])
            //            .prebuildCommand(displayName: "LicensePlist is processing licenses...",
            //                             executable: tool.path,
            //                             arguments: [],
            //                             outputFilesDirectory: context.pluginWorkDirectory)
        ]
    }
}

#endif
