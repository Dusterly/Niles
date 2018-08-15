import XCTest
import Foundation
import HTTP

class ResponseFormatterTests: XCTestCase {
	let formatter = ResponseFormatter(httpVersion: "HTTP/1.1")

	func testOutputsHTTPVersion() {
		let outputString = formatter.output(response: CustomizableResponse())
		XCTAssertTrue(outputString.hasPrefix("HTTP/1.1 "), "'\(outputString)' does not start with 'HTTP/1.1 '.")
	}

	func testOutputsStatusCode() {
		let response = CustomizableResponse(statusCode: .ok)
		let outputString = formatter.output(response: response)
		XCTAssertTrue(outputString.contains(" 200 OK"), "'\(outputString)' does not contain '200 OK'.")
	}
}

private struct CustomizableResponse: Response {
	var statusCode = StatusCode.ok
}

extension ResponseFormatterTests {
	static let allTests = [
		("testOutputsHTTPVersion", testOutputsHTTPVersion),
		("testOutputsStatusCode", testOutputsStatusCode),
	]
}
