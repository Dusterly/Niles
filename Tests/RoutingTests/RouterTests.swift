import XCTest
import Foundation
import HTTP
import Routing

class RouterTests: XCTestCase {
	let router = Router()

	func testCallsRouteWithMatchingVerbAndPath() {
		var didRoute = false
		router.at("/", using: .get) { didRoute = true }

		_ = router.respond(to: Request(verb: .get, path: "/"))

		XCTAssertTrue(didRoute)
	}

	func testDoesNotCallRouteWithDifferentVerb() {
		var didRoute = false
		router.at("/", using: .get) { didRoute = true }

		_ = router.respond(to: Request(verb: .post, path: "/"))

		XCTAssertFalse(didRoute)
	}

	func testDoesNotCallRouteWithDifferentPath() {
		var didRoute = false
		router.at("/somewhere", using: .get) { didRoute = true }

		_ = router.respond(to: Request(verb: .get, path: "/elsewhere"))

		XCTAssertFalse(didRoute)
	}

	func testReturnsResponse() {
		let returnedResponse = CustomizableResponse(statusCode: .ok)
		router.at("/", using: .get) { returnedResponse }

		let response = router.respond(to: Request(verb: .get, path: "/"))

		XCTAssertEqual(response as? CustomizableResponse, returnedResponse)
	}
}

private struct CustomizableResponse: Response {
	let statusCode: StatusCode
	var headers: [String: String]
	let body: Data?

	init(statusCode: StatusCode, headers: [String: String] = [:], body: String? = nil) {
		self.statusCode = statusCode
		self.headers = headers
		self.body = body?.data(using: .utf8)
	}
}

extension CustomizableResponse: Equatable {}
private func == (lhs: CustomizableResponse, rhs: CustomizableResponse) -> Bool {
	return lhs.statusCode == rhs.statusCode && lhs.headers == rhs.headers && lhs.body == rhs.body
}

extension RouterTests {
	static let allTests = [
		("testCallsRouteWithMatchingVerbAndPath", testCallsRouteWithMatchingVerbAndPath),
		("testDoesNotCallRouteWithDifferentVerb", testDoesNotCallRouteWithDifferentVerb),
		("testDoesNotCallRouteWithDifferentPath", testDoesNotCallRouteWithDifferentPath),
		("testReturnsResponse", testReturnsResponse),
	]
}
