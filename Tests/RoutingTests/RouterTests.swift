import XCTest
import Foundation
import HTTP
import Routing

class RouterTests: XCTestCase {
	let router = Router()

	func testCallsRoute() {
		var didRoute = false
		router.at("/", using: .get) { didRoute = true }

		router.respond(to: Request(verb: .get, path: "/"))

		XCTAssertTrue(didRoute)
	}
}

extension RouterTests {
	static let allTests = [
		("testCallsRoute", testCallsRoute)
	]
}
