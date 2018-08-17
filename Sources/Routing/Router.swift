import Foundation
import HTTP

public class Router {
	public typealias Handler = (Request) throws -> Response?
	public typealias HandlerWithParameters = (Request, [String: String]) throws -> Response?

	private var routes: [String: [Verb: HandlerWithParameters]] = [:]

	public init() {}

	public func respondToRequests(forPath path: String, using verb: Verb, with handler: @escaping Handler) {
		respondToRequests(forPath: path, using: verb) { request, _ in try handler(request) }
	}

	public func respondToRequests(forPath path: String, using verb: Verb, with handler: @escaping HandlerWithParameters) {
		routes[path] = [verb: handler]
	}

	public func response(routing request: Request) -> Response {
		guard let (handlers, parameters) = handlersAndParameters(forPath: request.path) else {
			return AutomaticResponse(
				statusCode: .notFound,
				body: "No resource exists for path '\(request.path)'."
			)
		}
		guard let handler = handlers[request.verb] else {
			return AutomaticResponse(
				statusCode: .methodNotAllowed,
				body: "Method \(request.verb) is not supported for \(request.path)"
			)
		}

		do {
			return try reponse(for: request, calling: handler, withParameters: parameters)
		} catch let response as Response where response.statusCode.isError {
			return response
		} catch {
			return AutomaticResponse(
				statusCode: .internalServerError,
				body: error.localizedDescription
			)
		}
	}

	private func handlersAndParameters(forPath path: String) -> ([Verb: HandlerWithParameters], [String: String])? {
		if let simplePathHandlers = routes[path] { return (simplePathHandlers, [:]) }

		return routes.compactMap { (pattern, handlers) -> ([Verb: HandlerWithParameters], [String: String])? in
			guard let parameters = properties(in: path, matchingKeysIn: pattern) else { return nil }
			return (handlers, parameters)
		}.first
	}

	private func reponse(
			for request: Request,
			calling handle: HandlerWithParameters,
			withParameters parameters: [String: String]) throws -> Response {
		return try handle(request, parameters) ?? AutomaticResponse(statusCode: .noContent)
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
