import XCTest
import Foundation
import HTTP

class RequestParserTests: XCTestCase {
	func testThrowsForMalformedRequest() {
		let parser = RequestParser()
		let malformedRequest = "invalid request"
		XCTAssertThrowsError(try parser.request(parsing: malformedRequest))
	}

	func testRecognizesGETVerb() throws {
		let parser = RequestParser()
		let request = try parser.request(parsing: "GET /path HTTP/1.1\n")
		XCTAssertEqual(request.verb, .get)
	}
}

extension RequestParserTests {
	static let allTests = [
		("testThrowsForMalformedRequest", testThrowsForMalformedRequest),
		("testRecognizesGETVerb", testRecognizesGETVerb),
	]
}
