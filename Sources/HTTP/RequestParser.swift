import Foundation

public class RequestParser {
	public init() {}

	public func request(reading input: ByteStream) throws -> Request {
		let verbData = try input.data(readingUntil: 32)
		guard let verbString = String(data: verbData, encoding: .ascii),
			let verb = Verb(rawValue: verbString) else { throw RequestParserError.some }
		let pathData = try input.data(readingUntil: 32)
		guard let pathString = String(data: pathData, encoding: .ascii) else { throw RequestParserError.some } 
		return Request(verb: verb, path: pathString)
	}
}

public enum RequestParserError: Error {
	case some
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
}
