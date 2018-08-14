import Foundation

public class RequestParser {
	public init() {}

	public func request(parsing input: String) throws -> Request {
		if input.hasPrefix(Verb.get.rawValue) {
			return Request(verb: .get)
		}
		if input.hasPrefix(Verb.post.rawValue) {
			return Request(verb: .post)
		}

		throw RequestParserError.some
	}
}

public enum RequestParserError: Error {
	case some
}
