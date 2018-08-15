import Foundation

public class RequestParser {
	public init() {}

	public func request(reading input: ByteStream) throws -> Request {
		var builder = RequestBuilder()
		builder.verb = try self.verb(reading: input)
		builder.path = try self.path(reading: input)
		builder.version = try input.string(readingUntil: 10)
		return try builder.request()
	}

	private func verb(reading stream: ByteStream) throws -> Verb {
		let verbString = try stream.nextWord()
		guard let verb = Verb(rawValue: verbString) else { throw RequestParserError.invalidFormat }
		return verb
	}

	private func path(reading stream: ByteStream) throws -> String {
		return try stream.nextWord()
	}
}

private extension ByteStream {
	func data(readingUntil stopByte: UInt8) throws -> Data {
		var bytes = Data()
		while true {
			guard let byte = try? nextByte() else { break }
			guard byte != stopByte else { break }
			bytes.append(byte)
		}
		return bytes
	}

	func string(readingUntil stopByte: UInt8) throws -> String {
		let wordData = try data(readingUntil: stopByte)
		guard let word = decodedString(ascii: wordData) else { throw RequestParserError.invalidFormat }
		return word
	}

	func nextWord() throws -> String {
		return try string(readingUntil: 32)
	}

	private func decodedString(ascii bytes: Data) -> String? {
		return String(bytes: bytes, encoding: .ascii)?
			.removingPercentEncoding
	}
}
