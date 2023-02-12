//
//  File.swift
//  
//
//  Created by Vladimir Vlasov on 07/02/2023.
//

import Foundation
import PackagePlugin

enum LicensePlistBuildToolError: Error {
    case workspaceNotFound
    case packageResolvedFileNotFound
    case configFileNotFound
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

@main
struct LicensePlistBuildTool: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        // The folder with checked out package sources
        let checkoutDirectoryPath = context.pluginWorkDirectory
            .removingLastComponent()
            .removingLastComponent()
            .removingLastComponent()
            .removingLastComponent()
            .appending(subpath: "checkouts")
        
        // Gets the workspace path in the project folder
        let fileManager = FileManager.default
        let projectDirectoryItems = try fileManager.contentsOfDirectory(atPath: context.xcodeProject.directory.string)
        guard let workspacePath = projectDirectoryItems.first(where: { $0.hasSuffix(".xcworkspace") }) else {
            throw LicensePlistBuildToolError.workspaceNotFound
        }
        
        // Package.resolved file path inside the workspace
        let packageResolvedPath = Path(fileManager.currentDirectoryPath)
            .appending(subpath: workspacePath)
            .appending(subpath: "xcshareddata/swiftpm/Package.resolved")
        guard fileManager.fileExists(atPath: packageResolvedPath.string) else {
            throw LicensePlistBuildToolError.packageResolvedFileNotFound
        }
        
        // Checks LicensePlist config
        let configPath = context.xcodeProject.directory.appending(subpath: "license_plist.yml")
        guard fileManager.fileExists(atPath: packageResolvedPath.string) else {
            throw LicensePlistBuildToolError.configFileNotFound
        }
        
        // Output directory inside build output directory
        let outputDirectoryPath = context.pluginWorkDirectory.appending(subpath: "LicensePlist")
        try fileManager.createDirectory(atPath: outputDirectoryPath.string, withIntermediateDirectories: true)
        
        return [
            .prebuildCommand(displayName: "LicensePlist is processing licenses...",
                             executable: try context.tool(named: "license-plist").path,
                             arguments: ["--build-tool",
                                         "--config-path", configPath,
                                         "--package-path", packageResolvedPath,
                                         "--package-checkout-path", checkoutDirectoryPath.string,
                                         "--output-path", outputDirectoryPath],
                             outputFilesDirectory: context.pluginWorkDirectory)
        ]
    }
}

#endif
