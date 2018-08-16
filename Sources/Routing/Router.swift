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

	public func response(routing request: Request) -> Response {
		guard let route = routes[request.path] else { return NotFoundResponse() }
		guard let handleRequest = route[request.verb] else { return MethodNotAllowedResponse() }
		return handleRequest()
	}
}

struct EmptyResponse: Response {
	var statusCode: StatusCode { return .noContent }
	var headers: [String : String] { return [:] }
	var body: Data? { return nil }
}

struct NotFoundResponse: Response {
	var statusCode: StatusCode { return .notFound }
	var headers: [String : String] { return [:] }
	var body: Data? { return nil }
}

struct MethodNotAllowedResponse: Response {
	var statusCode: StatusCode { return .methodNotAllowed }
	var headers: [String : String] { return [:] }
	var body: Data? { return nil }
}
