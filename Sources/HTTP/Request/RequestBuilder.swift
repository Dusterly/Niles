import Foundation

internal struct RequestBuilder {
	public var verb: Verb?
	public var path: String?
	public var version: String?
	public var headers: [String: String] = [:]
	public var body: Data?

	internal init() {}

	public func request() throws -> Request {
		guard let verb = verb else { throw RequestParserError.invalidFormat }
		guard let path = path else { throw RequestParserError.invalidFormat }
		guard let version = version else { throw RequestParserError.invalidFormat }
		return Request(
			verb: verb,
			path: path,
			version: version,
			headers: headers,
			body: body
		)
	}
}
