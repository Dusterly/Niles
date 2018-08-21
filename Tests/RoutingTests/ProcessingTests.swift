// swiftlint:disable force_try
// swiftlint:disable force_unwrapping

import XCTest
import Foundation
import HTTP
import Routing
import POSIXSockets

class ProcessingTests: XCTestCase {
	func testRespondsOnPOSIXSockets() throws {
		let router = self.router(respondingWith: "hello, world", atPath: "/")
		listenInBackground(onPort: 8000, routedBy: router)

		let response = responseToEmptyRequest(at: URL(string: "http://localhost:8000/")!)

		XCTAssertNil(response.error)
		XCTAssertEqual(response.response?.statusCode, 200)
		XCTAssertEqual(response.body, "hello, world".data(using: .ascii))
	}

	private func router(respondingWith body: String, atPath path: String) -> Router {
		let router = Router()
		router.respondToRequests(forPath: path, using: .get) { _ in body }
		return router
	}

	private func listenInBackground(onPort port: InetPort, routedBy router: Router) {
		DispatchQueue.global(qos: .background).async {
			let socket = try! POSIXServerSocket(listeningOn: port)
			socket.processRequests(routedBy: router)
		}
	}

	private func responseToEmptyRequest(at url: URL) -> SessionTaskResponse {
		var error: Error?
		var response: HTTPURLResponse?
		var data: Data?

		let expectation = self.expectation(description: "response")
		let session = URLSession(configuration: .default)
		session.dataTask(with: url) {
			data = $0
			response = $1 as? HTTPURLResponse
			error = $2
			expectation.fulfill()
		}.resume()
		waitForExpectations(timeout: 1)
		return SessionTaskResponse(error: error, response: response, body: data)
	}
}

private struct SessionTaskResponse {
	var error: Error?
	var response: HTTPURLResponse?
	var body: Data?
}

extension String: Response {
	public var statusCode: StatusCode { return .ok }
	public var headers: [String: String] { return [:] }
	public var body: Data? { return data(using: .ascii) }
}

extension ProcessingTests {
	static let allTests = [
		("testRespondsOnPOSIXSockets", testRespondsOnPOSIXSockets),
	]
}
