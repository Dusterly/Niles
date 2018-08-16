import XCTest
import Foundation
import HTTP
import Routing

class RouterTests: XCTestCase {
	let router = Router()

	func testCallsRouteWithMatchingVerbAndPath() {
		var didRoute = false
		router.at("/", using: .get) { didRoute = true }

		router.respond(to: Request(verb: .get, path: "/"))

		XCTAssertTrue(didRoute)
	}

	func testDoesNotCallRouteWithDifferentVerb() {
		var didRoute = false
		router.at("/", using: .get) { didRoute = true }

		router.respond(to: Request(verb: .post, path: "/"))

		XCTAssertFalse(didRoute)
	}

	func testDoesNotCallRouteWithDifferentPath() {
		var didRoute = false
		router.at("/somewhere", using: .get) { didRoute = true }

		router.respond(to: Request(verb: .get, path: "/elsewhere"))

		XCTAssertFalse(didRoute)
	}
}

extension RouterTests {
	static let allTests = [
		("testCallsRouteWithMatchingVerbAndPath", testCallsRouteWithMatchingVerbAndPath),
		("testDoesNotCallRouteWithDifferentVerb", testDoesNotCallRouteWithDifferentVerb),
		("testDoesNotCallRouteWithDifferentPath", testDoesNotCallRouteWithDifferentPath),
	]
}
