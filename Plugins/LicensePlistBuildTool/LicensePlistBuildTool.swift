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
        
        // !!!
        var dir = context.pluginWorkDirectory.removingLastComponent()
        print("BasicApp: \(dir)")
        dir = dir.removingLastComponent()
        print("BasicApp.output: \(dir)")
        dir = dir.removingLastComponent()
        print("plugins: \(dir)")
        dir = dir.removingLastComponent()
        print("SourcePackages: \(dir)")
        dir = dir.appending(subpath: "checkouts")
        print("checkouts: \(dir)")
        print("🐶 \(try FileManager.default.contentsOfDirectory(atPath: dir.string))")
        
        let resourcesDirectoryPath = context.pluginWorkDirectory
            .appending(subpath: target.displayName)
            .appending(subpath: "Resources")
        
        try FileManager.default.createDirectory(atPath: resourcesDirectoryPath.string, withIntermediateDirectories: true)
        
        let plistPath = resourcesDirectoryPath.appending(subpath: "Acknowledgements.plist")
        let latestResultPath = resourcesDirectoryPath.appending(subpath: "Acknowledgements.latest_result.txt")
        
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
