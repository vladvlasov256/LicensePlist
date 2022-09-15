import Foundation
import XCTest
@testable import LicensePlistCore

class EnvironmentTests: XCTestCase {
    func testSubscript() throws {
        let env = EnvironmentImpl<MockKey>()
        
//        XCTAssertEqual(env[.term], ProcessInfo.processInfo.environment["TERM"])
//        XCTAssertEqual(env[.githubToken], ProcessInfo.processInfo.environment["LICENSE_PLIST_GITHUB_TOKEN"])
//        XCTAssertEqual(env[.noColor], ProcessInfo.processInfo.environment["NO_COLOR"])
        XCTAssertEqual(env[.hoge], ProcessInfo.processInfo.environment["NO_COLOR"])
    }
}

enum MockKey : String, EnvironmentKeyProtocol {
    case hoge
}
