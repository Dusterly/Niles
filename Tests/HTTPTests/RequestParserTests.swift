import XCTest
import Foundation
import HTTP

class RequestParserTests: XCTestCase {
	func testThrowsForMalformedRequest() {
		let parser = RequestParser()
		let malformedRequest = "invalid request"
		let stream = InputStream(openWith: malformedRequest.data(using: .ascii)!)
		XCTAssertThrowsError(try parser.request(reading: stream))
	}

	func testRecognizesGETVerb() throws {
		let parser = RequestParser()
		let request = try parser.request(reading: InputStream(openWith: "GET /path HTTP/1.1\n".data(using: .ascii)!))
		XCTAssertEqual(request.verb, .get)
	}

	func testRecognizesPOSTVerb() throws {
		let parser = RequestParser()
		let request = try parser.request(reading: InputStream(openWith: ("POST /path HTTP/1.1\n" +
			"Content-Length: 4\n\n" +
			"body").data(using: .ascii)!))
		XCTAssertEqual(request.verb, .post)
	}

	func testRecognizesPath() throws {
		let parser = RequestParser()
		let request = try parser.request(reading: InputStream(openWith: "GET /path HTTP/1.1\n".data(using: .ascii)!))
		XCTAssertEqual(request.path, "/path")
	}
}

extension InputStream: ByteStream {
	public convenience init(openWith data: Data) {
		self.init(data: data)
		open()
	}

	public func nextByte() throws -> UInt8 {
		var buffer: [UInt8] = Array(repeating: 0, count: 1)
		let actualCount = read(&buffer, maxLength: 1)
		guard actualCount == 1 else { throw StreamError.endOfStream }
		return buffer[0]
	}
}

enum StreamError: Error {
	case endOfStream
}

extension RequestParserTests {
	static let allTests = [
		("testThrowsForMalformedRequest", testThrowsForMalformedRequest),
		("testRecognizesGETVerb", testRecognizesGETVerb),
		("testRecognizesPOSTVerb", testRecognizesPOSTVerb),
		("testRecognizesPath", testRecognizesPath),
	]
}
