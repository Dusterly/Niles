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

	func testRecognizesVersion() throws {
		let request = try self.request(with: "GET /path HTTP/1.1\n")
		XCTAssertEqual(request.version, "HTTP/1.1")
	}

	func testDoesNotRequireNewlineAfterGET() throws {
		let request = try self.request(with: "GET /path HTTP/1.1")
		XCTAssertEqual(request.version, "HTTP/1.1")
	}

	func testIgnoresCarriageReturn() throws {
		let request = try self.request(with: "GET /path HTTP/1.1\r\n")
		XCTAssertEqual(request.version, "HTTP/1.1")
	}

	func testRecognizesHeaders() throws {
		let request = try self.request(with: "GET /path HTTP/1.1\n" +
			"SomeHeader: some value\n\n")
		XCTAssertEqual(request.headers["SomeHeader"], "some value")
	}

	func testAllowsColonInHeaderValues() throws {
		let request = try self.request(with: "GET /path HTTP/1.1\n" +
			"SomeHeader: value: x\n\n")
		XCTAssertEqual(request.headers["SomeHeader"], "value: x")
	}

	func testRecognizesBody() throws {
		let request = try self.request(with: "POST /path HTTP/1.1\n" +
			"Content-Length: 4\n\n" +
			"body")
		XCTAssertEqual(string(fromASCII: request.body), "body")
	}

	private func request(with text: String) throws -> Request {
		let data = text.data(using: .ascii)!
		let stream = InputStream(openWith: data)
		return try parser.request(reading: stream)
	}

	private func string(fromASCII data: Data?) -> String? {
		guard let data = data else { return nil }
		return String(data: data, encoding: .ascii)
	}
}

extension InputStream: DataReadable {
	public convenience init(openWith data: Data) {
		self.init(data: data)
		open()
	}

	public func data(readingLength count: Int) throws -> Data {
		var buffer: [UInt8] = Array(repeating: 0, count: count)
		let actualCount = read(&buffer, maxLength: count)
		guard actualCount == count else { throw StreamError.endOfStream }
		return Data(bytes: buffer)
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
		("testRecognizesVersion", testRecognizesVersion),
		("testDoesNotRequireNewlineAfterGET", testDoesNotRequireNewlineAfterGET),
		("testIgnoresCarriageReturn", testIgnoresCarriageReturn),
		("testRecognizesHeaders", testRecognizesHeaders),
		("testAllowsColonInHeaderValues", testAllowsColonInHeaderValues),
		("testRecognizesBody", testRecognizesBody),
	]
}
