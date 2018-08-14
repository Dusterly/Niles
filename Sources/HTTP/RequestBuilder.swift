internal struct RequestBuilder {
	public var verb: Verb?
	public var path: String?

	internal init() {}

	public func request() throws -> Request {
		guard let verb = verb, let path = path else { throw RequestParserError.some }
		return Request(verb: verb, path: path)
	}
}
