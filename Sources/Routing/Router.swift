import Foundation
import HTTP

public class Router {
	public typealias Handler = (Request) throws -> Response?

	private var routes: [String: [Verb: Handler]] = [:]

	public init() {}

	public func respondToRequests(forPath path: String, using verb: Verb, with handler: @escaping Handler) {
		routes[path] = [verb: handler]
	}

	public func response(routing request: Request) -> Response {
		guard let route = routes[request.path] else {
			return AutomaticResponse(
				statusCode: .notFound,
				body: "No resource exists for path '\(request.path)'."
			)
		}
		guard let handle = route[request.verb] else {
			return AutomaticResponse(
				statusCode: .methodNotAllowed,
				body: "Method \(request.verb) is not supported for \(request.path)"
			)
		}
		do {
			return try handle(request) ?? AutomaticResponse(statusCode: .noContent)
		} catch let response as Response where response.statusCode.isError {
			return response
		} catch {
			return AutomaticResponse(
				statusCode: .internalServerError,
				body: error.localizedDescription
			)
		}
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
