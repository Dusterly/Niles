import Dispatch
import Foundation
import HTTP

extension ServerSocket {
	public func processRequests(routedBy router: Router) {
		while let client = try? self.nextClient() {
			DispatchQueue.global(qos: .background).async {
				router.processRequest(from: client)
			}
		}
		print("socket closed")
	}
}

private extension Router {
	func processRequest(from client: DataReadable&DataWritable) {
		guard let request = try? request(reading: client) else {
			write(StatusCode.badRequest, to: client, httpVersion: "HTTP/1.0")
			return
		}
		let response = self.response(routing: request)
		write(response, to: client, httpVersion: request.version)
	}

	private func request(reading stream: DataReadable) throws -> Request {
		let parser = RequestParser()
		return try parser.request(reading: stream)
	}

	private func write(_ response: Response, to stream: DataWritable, httpVersion: String) {
		let formatter = ResponseFormatter(httpVersion: httpVersion)
		try? formatter.write(response: response, to: stream)
	}
}

extension StatusCode: Response {
	public var statusCode: StatusCode { return self }
	public var headers: [String: String] { return [:] }
	public var body: Data? { return message?.data(using: .ascii) }
	private var message: String? {
		switch self {
		case .noContent: return nil
		default: return rawValue
		}
	}
}
