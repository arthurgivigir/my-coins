import XCTest
@testable import MyCoinsCore

final class MyCoinsCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MyCoinsCore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
