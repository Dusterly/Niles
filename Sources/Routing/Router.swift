import Foundation
import HTTP

public class Router {
	private var routes: [String: [Verb: (() -> Response)]] = [:]

	public init() {}

	public func at(_ path: String, using verb: Verb, perform handler: @escaping () -> Void) {
		at(path, using: verb) {
			() -> Response in
			handler()
			return AutomaticResponse(statusCode: .noContent)
		}
	}

	public func at(_ path: String, using verb: Verb, perform handler: @escaping () -> Response) {
		routes[path] = [verb: handler]
	}

	public func response(routing request: Request) -> Response {
		guard let route = routes[request.path] else { return AutomaticResponse(statusCode: .notFound) }
		guard let handleRequest = route[request.verb] else { return AutomaticResponse(statusCode: .methodNotAllowed) }
		return handleRequest()
	}
}

struct AutomaticResponse: Response {
	var statusCode: StatusCode
	var headers: [String : String] { return [:] }
	var body: Data? { return nil }
}
