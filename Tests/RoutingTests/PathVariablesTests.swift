import XCTest
import Foundation
import Routing

class PathVariablesTests: XCTestCase {
	func testReturnsNilIfPathsDoNotMatch() {
		XCTAssertNil(properties(in: "/some/path", matchingKeysIn: "/some/other/path"))
	}

	func testReturnsEmptyDictionaryForPathWithNoArguments() {
		XCTAssertEqual(properties(in: "/", matchingKeysIn: "/"), [:])
	}

	func testPassesArgumentsToHandler() {
		XCTAssertEqual(properties(in: "/yo", matchingKeysIn: "/{arg}"), ["arg": "yo"])
	}

	func testMatchesAnyPartOfPath() {
		XCTAssertEqual(properties(in: "/some/path?id=yo", matchingKeysIn: "/some/path?id={arg}"), ["arg": "yo"])
	}

	func testFindsMultipleVariables() {
		let props = properties(
			in: "/some/path?min=1&max=2",
			matchingKeysIn: "/some/path?min={min}&max={max}")
		XCTAssertEqual(props, ["min": "1", "max": "2"])
	}

	func testReturnsNilIfMultipleVariablesDoNotMatch() {
		XCTAssertNil(properties(in: "/some/path?min=1&mux=2", matchingKeysIn: "/some/path?min={min}&max={max}"))
	}
}

extension PathVariablesTests {
	static let allTests = [
		("testReturnsNilIfPathsDoNotMatch", testReturnsNilIfPathsDoNotMatch),
		("testReturnsEmptyDictionaryForPathWithNoArguments", testReturnsEmptyDictionaryForPathWithNoArguments),
		("testPassesArgumentsToHandler", testPassesArgumentsToHandler),
		("testMatchesAnyPartOfPath", testMatchesAnyPartOfPath),
		("testFindsMultipleVariables", testFindsMultipleVariables),
		("testReturnsNilIfMultipleVariablesDoNotMatch", testReturnsNilIfMultipleVariablesDoNotMatch),
	]
}
