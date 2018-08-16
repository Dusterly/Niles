import Foundation
import HTTP

public class Router {
	private var routes: [String: [Verb: (() -> Response)]] = [:]

	public init() {}

	public func at(_ path: String, using verb: Verb, perform handler: @escaping () -> Void) {
		at(path, using: verb) {
			() -> Response in
			handler()
			return EmptyResponse()
		}
	}

	public func at(_ path: String, using verb: Verb, perform handler: @escaping () -> Response) {
		routes[path] = [verb: handler]
	}

	public func response(routing request: Request) -> Response? {
		return routes[request.path]?[request.verb]?()
	}
}

struct EmptyResponse: Response {
	var statusCode: StatusCode { return .noContent }
	var headers: [String : String] { return [:] }
	var body: Data? { return nil }
}
