public class RequestParser {
	public init() {}

	public func request(parsing input: String) throws -> Request {
		if input.hasPrefix("GET") {
			return Request(verb: .get)
		}

		throw RequestParserError.some
	}
}

public enum RequestParserError: Error {
	case some
}
