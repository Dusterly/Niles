import Foundation

public struct Request {
	public var verb: Verb
	public var path: String
	public var version: String
	public var headers: [String: String]
	public var body: Data?
}
