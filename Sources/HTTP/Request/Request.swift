import Foundation

public struct Request {
	public var verb: Verb
	public var path: String
	public var version: String
	public var headers: [String: String]
	public var body: Data?

	public init(verb: Verb,
	            path: String,
	            version: String = "HTTP/1.1",
	            headers: [String: String] = [:],
	            body: Data? = nil) {

		self.verb = verb
		self.path = path
		self.version = version
		self.headers = headers
		self.body = body
	}
}
