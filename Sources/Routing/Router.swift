import HTTP

public class Router {
	private var routes: [String: [Verb: (() -> Void)]] = [:]

	public init() {}

	public func at(_ path: String, using verb: Verb, perform handler: @escaping () -> Void) {
		routes[path] = [verb: handler]
	}

	public func respond(to request: Request) {
		routes[request.path]?[request.verb]?()
	}
}
