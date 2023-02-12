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
}

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
        
        let checkoutDirectoryPath = context.pluginWorkDirectory
            .removingLastComponent()
            .removingLastComponent()
            .removingLastComponent()
            .removingLastComponent()
            .appending(subpath: "checkouts")
//        print("🐶 \(try FileManager.default.contentsOfDirectory(atPath: checkoutDirectoryPath.string))")
        
//        context.xcodeProject.directory
        
        let fileManager = FileManager.default
//        let projectDirectoryItems = try fileManager.contentsOfDirectory(atPath: context.xcodeProject.directory.string)
//        guard let workspacePath = projectDirectoryItems.first(where: { $0.hasSuffix(".xcworkspace") }) else {
//            throw LicensePlistBuildToolError.workspaceNotFound
//        }
        
//        let resolvedPath = Path(fileManager.currentDirectoryPath)
//            .appending(subpath: workspacePath)
//            .appending(subpath: "xcshareddata/swiftpm/Package.resolved")
//        guard fileManager.fileExists(atPath: resolvedPath.string) else {
//            throw LicensePlistBuildToolError.packageResolvedFileNotFound
//        }
        
//        target.product
        
//        /Users/vlad/misc/github/BasicApp/BasicApp.xcworkspace/xcshareddata/swiftpm/Package.resolved
        
//        let xcodeprojPackageResolvedPath = validatedPath
//            .appendingPathComponent("project.xcworkspace")
//            .appendingPathComponent("xcshareddata")
//            .appendingPathComponent("swiftpm")
//            .appendingPathComponent("Package.resolved")
//
//        let xcworkspacePackageResolvedPath = validatedPath
//            .deletingPathExtension()
//            .appendingPathExtension("xcworkspace")
//            .appendingPathComponent("xcshareddata")
//            .appendingPathComponent("swiftpm")
//            .appendingPathComponent("Package.resolved")
        
//        let projDir = context.xcodeProject.directory
//        let configPath = projDir.appending(subpath: "license_plist.yml")
//        let data = try Data(contentsOf: URL(fileURLWithPath: configPath.string))
//        print("🐶 \(String(data: data, encoding: .utf8) ?? "")")
        
        // TODO: Check whether or not it's correct to use displayName here
        // TODO: Get output path from the config
        let outputDirectoryPath = context.pluginWorkDirectory
            .appending(subpath: target.displayName)
            .appending(subpath: "Resources/Settings.bundle")
        
        
        try fileManager.createDirectory(atPath: outputDirectoryPath.string, withIntermediateDirectories: true)
        
//        try fileManager.contentsOfDirectory(atPath: outputDirectoryPath.string).forEach { item in
//            let path = outputDirectoryPath.appending(subpath: item)
//            try fileManager.removeItem(atPath: path.string)
//        }
        
//        let originalOutputPath = context.xcodeProject.directory.appending(subpath: "Resources/Settings.bundle")
//        let originLatestResultPath = originalOutputPath.appending(subpath: "Acknowledgements.latest_result.txt")
//        let latestResultPath = outputDirectoryPath.appending(subpath: "Acknowledgements.latest_result.txt")
//        if fileManager.fileExists(atPath: originLatestResultPath.string) {
//            try fileManager.copyItem(atPath: originLatestResultPath.string, toPath: latestResultPath.string)
//        }
        
        // TODO: add warnings for '--build-tool' usage (like no checkout path, etc.)
        // TODO: filter target dependencies
        
        // TODO: Use options
        let plistPath = outputDirectoryPath.appending(subpath: "Acknowledgements.plist")
        // TODO: Use prefix: "\(options.prefix).latest_result.txt"
        let latestResultPath = outputDirectoryPath.appending(subpath: "Acknowledgements.latest_result.txt")
        
        return [
            .buildCommand(displayName: "LicensePlist is processing licenses...",
                          executable: tool.path,
                          arguments: ["--build-tool",
//                                      "--package-path", resolvedPath,
                                      "--package-checkout-path", checkoutDirectoryPath.string,
                                      "--output-path", outputDirectoryPath
                                     ],
                          outputFiles: [plistPath, latestResultPath])
            //            .prebuildCommand(displayName: "LicensePlist is processing licenses...",
            //                             executable: tool.path,
            //                             arguments: [],
            //                             outputFilesDirectory: context.pluginWorkDirectory)
        ]
    }
}

#endif
