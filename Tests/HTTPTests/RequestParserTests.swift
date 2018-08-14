import XCTest
import Foundation
import HTTP

class RequestParserTests: XCTestCase {
	func testThrowsForMalformedRequest() {
		let parser = RequestParser()
		let malformedRequest = "invalid request"
		XCTAssertThrowsError(try parser.request(parsing: malformedRequest))
	}
}

extension RequestParserTests {
	static let allTests = [
		("testThrowsForMalformedRequest", testThrowsForMalformedRequest),
	]
}
