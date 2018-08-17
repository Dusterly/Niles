import Foundation
import HTTP

public class Router {
	public typealias Handler = (Request) throws -> Response?
	public typealias HandlerWithArguments = (Request, [String: String]) throws -> Response?

	private var routes: [String: [Verb: HandlerWithArguments]] = [:]

	public init() {}

	public func respondToRequests(forPath path: String, using verb: Verb, with handler: @escaping Handler) {
		routes[path] = [verb: { request, _ in try handler(request) }]
	}

	public func respondToRequests(forPath path: String, using verb: Verb, with handler: @escaping HandlerWithArguments) {
		routes[path] = [verb: handler]
	}

	public func response(routing request: Request) -> Response {
		guard let (handlers, parameters) = self.routes(forPath: request.path) else {
			return AutomaticResponse(
				statusCode: .notFound,
				body: "No resource exists for path '\(request.path)'."
			)
		}
		guard let handle = handlers[request.verb] else {
			return AutomaticResponse(
				statusCode: .methodNotAllowed,
				body: "Method \(request.verb) is not supported for \(request.path)"
			)
		}

		do {
			return try handle(request, parameters) ?? AutomaticResponse(statusCode: .noContent)
		} catch let response as Response where response.statusCode.isError {
			return response
		} catch {
			return AutomaticResponse(
				statusCode: .internalServerError,
				body: error.localizedDescription
			)
		}
	}

	private func routes(forPath path: String) -> ([Verb: HandlerWithArguments], [String: String])? {
		if let simplePathHandlers = routes[path] { return (simplePathHandlers, [:]) }

		return routes.compactMap { (pattern, handlers) -> ([Verb: HandlerWithArguments], [String: String])? in
			guard let parameters = properties(in: path, matchingKeysIn: pattern) else { return nil }
			return (handlers, parameters)
		}.first
	}
}

struct AutomaticResponse: Response {
	var statusCode: StatusCode
	var headers: [String : String] { return [:] }
	var body: Data?

	init(statusCode: StatusCode, body: String? = nil) {
		self.statusCode = statusCode
		self.body = body?.data(using: .utf8)
	}
}
