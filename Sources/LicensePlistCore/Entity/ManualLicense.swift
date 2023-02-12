import Foundation
import LoggerAPI

public struct ManualLicense: License, Equatable {
    public let library: Manual
    public let body: String

    public static func==(lhs: ManualLicense, rhs: ManualLicense) -> Bool {
        return lhs.library == rhs.library &&
        lhs.body == rhs.body
    }
}

extension ManualLicense: CustomStringConvertible {
    public var description: String {
        return [["name: \(library.name)",
            "nameSpecified: \(library.nameSpecified ?? "")",
            "version: \(library.version ?? "")"]
        .joined(separator: ", "),
                "body: \(String(body.prefix(20)))…"]
        .joined(separator: "\n")
    }
}

extension ManualLicense {
    public static func load(_ manuals: [Manual]) -> [ManualLicense] {
        return manuals.map {
            return ManualLicense(library: $0, body: $0.body ?? "")
        }
    }
    
    public static func readFromDisk(_ libraries: [GitHub], checkoutPath: URL) -> [ManualLicense] {
        return libraries.compactMap { library in
            let owner = library.owner
            let name = library.name
            Log.info("license reading from disk start(owner: \(owner), name: \(name))")
            
            // Check several variants of license file name
            for fileName in ["LICENSE", "LICENSE.txt"] {
                do {
                    let url = checkoutPath.appendingPathComponent(name).appendingPathComponent(fileName)
                    let content = try String(contentsOf: url)
                    let library = Manual(name: name,
                                         source: library.source,
                                         nameSpecified: library.nameSpecified,
                                         version: library.version)
                    // Return the content of the first matched file
                    return ManualLicense(library: library, body: content)
                } catch {
                    continue
                }
            }
            
            Log.warning("Failed to read from disk \(name)")
            return nil
        }
    }
}
