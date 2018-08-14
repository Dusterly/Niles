public class RequestParser {
	public init() {}

	public func request(parsing input: String) throws {
		throw RequestParserError.some
	}
}

public enum RequestParserError: Error {
	case some
}
