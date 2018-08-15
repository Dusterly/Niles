import Foundation

public class RequestParser {
	public init() {}

	public func request(reading input: ByteStream) throws -> Request {
		var builder = RequestBuilder()
		builder.verb = try self.verb(reading: input)
		builder.path = try self.path(reading: input)
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

	func nextWord() throws -> String {
		let wordData = try data(readingUntil: 32)
		guard let word = String(data: wordData, encoding: .ascii) else { throw RequestParserError.invalidFormat }
		return word
	}
}
