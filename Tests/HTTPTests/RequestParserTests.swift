import XCTest
import Foundation
import HTTP

class RequestParserTests: XCTestCase {
	let parser = RequestParser()

	func testThrowsForMalformedRequest() {
		XCTAssertThrowsError(try self.request(with: "invalid request"))
	}

	func testRecognizesGETVerb() throws {
		let request = try self.request(with: "GET /path HTTP/1.1\n")
		XCTAssertEqual(request.verb, .get)
	}

	func testRecognizesPOSTVerb() throws {
		let request = try self.request(with: "POST /path HTTP/1.1\n" +
			"Content-Length: 4\n\n" +
			"body")
		XCTAssertEqual(request.verb, .post)
	}

	func testRecognizesPath() throws {
		let request = try self.request(with: "GET /path HTTP/1.1\n")
		XCTAssertEqual(request.path, "/path")
	}

	func testDecodesPathToUTF8() throws {
		let request = try self.request(with: "GET /f%C3%B6retag HTTP/1.1\n")
		XCTAssertEqual(request.path, "/företag")
	}

	private func request(with text: String) throws -> Request {
		let data = text.data(using: .ascii)!
		let stream = InputStream(openWith: data)
		return try parser.request(reading: stream)
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
		("testDecodesPathToUTF8", testDecodesPathToUTF8),
	]
}
