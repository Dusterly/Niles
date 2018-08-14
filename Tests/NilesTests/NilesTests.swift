import XCTest
@testable import Niles

final class NilesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Niles().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
