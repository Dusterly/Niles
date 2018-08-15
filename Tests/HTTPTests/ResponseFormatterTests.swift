import XCTest
import Foundation
import HTTP

class ResponseFormatterTests: XCTestCase {
	let formatter = ResponseFormatter(httpVersion: "HTTP/1.1")

	func testOutputsHTTPVersion() {
		let outputString = formatter.response()
		XCTAssertTrue(outputString.hasPrefix("HTTP/1.1 "), "'\(outputString)' does not start with 'HTTP/1.1 '.")
	}
}

extension ResponseFormatterTests {
	static let allTests = [
		("testOutputsHTTPVersion", testOutputsHTTPVersion),
	]
}
