import Foundation
import HTTP

public class Router {
	public typealias Handler = (Request) throws -> Response?

	private var routes: [String: [Verb: Handler]] = [:]

	public init() {}

	public func at(_ path: String, using verb: Verb, perform handler: @escaping Handler) {
		routes[path] = [verb: handler]
	}

	public func response(routing request: Request) -> Response {
		guard let route = routes[request.path] else { return AutomaticResponse(statusCode: .notFound) }
		guard let handle = route[request.verb] else { return AutomaticResponse(statusCode: .methodNotAllowed) }
		do {
			return try handle(request) ?? AutomaticResponse(statusCode: .noContent)
		} catch let response as Response where response.statusCode.isError {
			return response
		} catch {
			return AutomaticResponse(statusCode: .internalServerError)
		}
	}
}

struct AutomaticResponse: Response {
	var statusCode: StatusCode
	var headers: [String : String] { return [:] }
	var body: Data? { return nil }
}
