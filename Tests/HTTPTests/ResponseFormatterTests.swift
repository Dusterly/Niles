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

	func testOutputsHeaders() {
		let response = CustomizableResponse(headers: ["SomeHeader": "value"])
		let outputString = formatter.output(response: response)
		XCTAssertTrue(outputString.contains("SomeHeader: value"), "'\(outputString)' does not contain header 'SomeHeader: value'.")
	}
}

private struct CustomizableResponse: Response {
	var statusCode: StatusCode
	var headers: [String: String]

	init(statusCode: StatusCode = .ok, headers: [String: String] = [:]) {
		self.statusCode = statusCode
		self.headers = headers
	}
}

extension ResponseFormatterTests {
	static let allTests = [
		("testOutputsHTTPVersion", testOutputsHTTPVersion),
		("testOutputsStatusCode", testOutputsStatusCode),
		("testOutputsHeaders", testOutputsHeaders),
	]
}
