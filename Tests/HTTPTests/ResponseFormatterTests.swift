import XCTest
import Foundation
import HTTP

class ResponseFormatterTests: XCTestCase {
	let formatter = ResponseFormatter(httpVersion: "HTTP/1.1")

	func testOutputsHTTPVersion() {
		let outputString = formatter.output(response: Response(statusCode: .ok))
		XCTAssertTrue(outputString.hasPrefix("HTTP/1.1 "), "'\(outputString)' does not start with 'HTTP/1.1 '.")
	}

	func testOutputsStatusCode() {
		let response = Response(statusCode: .ok)
		let outputString = formatter.output(response: response)
		XCTAssertTrue(outputString.contains(" 200 OK"), "'\(outputString)' does not contain '200 OK'.")
	}
}

extension ResponseFormatterTests {
	static let allTests = [
		("testOutputsHTTPVersion", testOutputsHTTPVersion),
		("testOutputsStatusCode", testOutputsStatusCode),
	]
}
