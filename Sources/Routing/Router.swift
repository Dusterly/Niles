import HTTP

public class Router {
	private var route: (() -> Void)?

	public init() {}

	public func at(_ path: String, using: Verb, perform handler: @escaping () -> Void) {
		route = handler
	}

	public func respond(to request: Request) {
		route?()
	}
}
