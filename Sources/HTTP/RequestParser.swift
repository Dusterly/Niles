import Foundation

public class RequestParser {
	public init() {}

	public func request(reading input: ByteStream) throws -> Request {
		var builder = RequestBuilder()
		builder.verb = try self.verb(reading: input)
		builder.path = try self.path(reading: input)
		builder.version = try input.string(readingUntil: .newline)
		return try builder.request()
	}

	private func verb(reading stream: ByteStream) throws -> Verb {
		let verbString = try stream.string(readingUntil: .space)
		guard let verb = Verb(rawValue: verbString) else { throw RequestParserError.invalidFormat }
		return verb
	}

	private func path(reading stream: ByteStream) throws -> String {
		return try stream.string(readingUntil: .space)
	}
}

private enum ControlByte: UInt8 {
	case newline = 10
	case space = 32
}

private extension ByteStream {
	func data(readingUntil stopByte: ControlByte) throws -> Data {
		var bytes = Data()
		while true {
			guard let byte = try? nextByte() else { break }
			guard byte != stopByte.rawValue else { break }
			bytes.append(byte)
		}
		return bytes
	}

	func string(readingUntil stopByte: ControlByte) throws -> String {
		let wordData = try data(readingUntil: stopByte)
		guard let word = decodedString(ascii: wordData) else { throw RequestParserError.invalidFormat }
		return word
	}

	private func decodedString(ascii bytes: Data) -> String? {
		return String(bytes: bytes, encoding: .ascii)?
			.removingPercentEncoding
	}
}
