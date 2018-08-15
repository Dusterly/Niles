import Foundation

public class RequestParser {
	public init() {}

	public func request(reading input: DataReadable) throws -> Request {
		var builder = RequestBuilder()
		builder.verb = try self.verb(reading: input)
		builder.path = try self.path(reading: input)
		builder.version = try input.string(readingUntil: .newline)

		while let (name, value) = try header(reading: input) {
			builder.headers[name] = value.trimmingCharacters(in: .whitespaces)
		}

		builder.body = try body(reading: input, withLengthFrom: builder.headers)

		return try builder.request()
	}

	private func header(reading stream: DataReadable) throws -> (String, String)? {
		let line = try stream.string(readingUntil: .newline)
		guard line != "" else { return nil }
		guard let rangeOfColon = line.range(of: ":") else { throw RequestParserError.invalidFormat }

		let name = line[line.startIndex..<rangeOfColon.lowerBound]
		let value = line[rangeOfColon.upperBound..<line.endIndex]
		return (String(name), String(value))
	}

	private func verb(reading stream: DataReadable) throws -> Verb {
		let verbString = try stream.string(readingUntil: .space)
		guard let verb = Verb(rawValue: verbString) else { throw RequestParserError.invalidFormat }
		return verb
	}

	private func path(reading stream: DataReadable) throws -> String {
		return try stream.string(readingUntil: .space)
	}

	private func body(reading stream: DataReadable, withLengthFrom headers: [String: String]) throws -> Data? {
		guard let contentLengthHeader = headers["Content-Length"] else { return nil }
		guard let contentLength = Int(contentLengthHeader) else { throw RequestParserError.invalidFormat }
		return try stream.data(readingLength: contentLength)
	}
}

private enum ControlByte: UInt8 {
	case newline = 10
	case space = 32
}

private extension DataReadable {
	func nextByte() throws -> UInt8 {
		let data = try self.data(readingLength: 1)
		return data[0]
	}

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
			.trimmingCharacters(in: .controlCharacters)
			.removingPercentEncoding
	}
}
