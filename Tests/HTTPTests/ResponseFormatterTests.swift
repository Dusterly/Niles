import XCTest
import Foundation
import HTTP

class ResponseFormatterTests: XCTestCase {
	let formatter = ResponseFormatter(httpVersion: "HTTP/1.1")

	func testOutputsHTTPVersion() throws {
		let outputString = try output(formatting: CustomizableResponse())
		XCTAssertTrue(outputString.hasPrefix("HTTP/1.1 "), "'\(outputString)' does not start with 'HTTP/1.1 '.")
	}

	func testOutputsStatusCode() throws {
		let outputString = try output(formatting: CustomizableResponse(statusCode: .ok))
		assert(outputString, matchesRegularExpression: " 200 OK$")
	}

	func testOutputsHeaders() throws {
		let outputString = try output(formatting: CustomizableResponse(headers: ["SomeHeader": "value"]))
		assert(outputString, matchesRegularExpression: "^SomeHeader: value$")
	}

	func testOutputsBody() throws {
		let outputString = try output(formatting: CustomizableResponse(body: "body"))
		assert(outputString, matchesRegularExpression: "^Content-Length: 4$")
		assert(outputString, matchesRegularExpression: "^\\r\\nbody$")
	}

	func testHonorsExplicitContentLength() throws {
		let response = CustomizableResponse(headers: ["Content-Length": "3"], body: "body")
		let outputString = try output(formatting: response)
		assert(outputString, matchesRegularExpression: "^Content-Length: 3$")
		assert(outputString, matchesRegularExpression: "^\\r\\nbody$")
	}

	func testOutputsEmptyNewlineEvenIfNoBody() throws {
		let outputString = try output(formatting: CustomizableResponse(statusCode: .noContent))
		assert(outputString, matchesRegularExpression: "\\r\\n\\r\\n$")
	}

	private func output(formatting response: Response) throws -> String {
		let output = VisibleOutput()
		try formatter.write(response: response, to: output)
		return output.string
	}

	private func assert(_ value: String, matchesRegularExpression regex: String, line: UInt = #line) {
		XCTAssertNotNil(value .range(of: "(?m)\(regex)", options: [.regularExpression]),
						"'\(value)' does not match regular expression '\(regex)'.", line: line)
	}
}

private class VisibleOutput: DataWritable {
	private var data = Data()

	var string: String {
		return String(data: data, encoding: .utf8) ?? ""
	}

	func write(_ data: Data) {
		self.data.append(data)
	}
}

private struct CustomizableResponse: Response {
	var statusCode: StatusCode
	var headers: [String: String]
	var body: Data?

	init(statusCode: StatusCode = .ok, headers: [String: String] = [:], body: String? = nil) {
		self.statusCode = statusCode
		self.headers = headers
		self.body = body?.data(using: .ascii)
	}
}

extension ResponseFormatterTests {
	static let allTests = [
		("testOutputsHTTPVersion", testOutputsHTTPVersion),
		("testOutputsStatusCode", testOutputsStatusCode),
		("testOutputsHeaders", testOutputsHeaders),
		("testOutputsBody", testOutputsBody),
		("testOutputsEmptyNewlineEvenIfNoBody", testOutputsEmptyNewlineEvenIfNoBody),
		("testHonorsExplicitContentLength", testHonorsExplicitContentLength),
	]
}
