import Foundation

public class RequestParser {
	public init() {}

	public func request(parsing input: String) throws -> Request {
		let verbString = String(input.prefix { $0 != " " })
		guard let verb = Verb(rawValue: verbString) else { throw RequestParserError.some }
		return Request(verb: verb)
	}
}

public enum RequestParserError: Error {
	case some
}
