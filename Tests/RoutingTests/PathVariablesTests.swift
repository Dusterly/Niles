import XCTest
import Foundation
import Routing

class PathVariablesTests: XCTestCase {
	func testReturnsNilIfPathsDoNotMatch() {
		XCTAssertNil(extractVariables(from: "/some/path", matching: "/some/other/path"))
	}

	func testReturnsEmptyDictionaryForPathWithNoArguments() {
		XCTAssertEqual(extractVariables(from: "/", matching: "/"), [:])
	}

	func testPassesArgumentsToHandler() {
		XCTAssertEqual(extractVariables(from: "/yo", matching: "/{arg}"), ["arg": "yo"])
	}

	func testMatchesAnyPartOfPath() {
		XCTAssertEqual(extractVariables(from: "/some/path?id=yo", matching: "/some/path?id={arg}"), ["arg": "yo"])
	}

	func testFindsMultipleVariables() {
		XCTAssertEqual(extractVariables(from: "/some/path?min=1&max=2", matching: "/some/path?min={min}&max={max}"), ["min": "1", "max": "2"])
	}

	func testReturnsNilIfMultipleVariablesDoNotMatch() {
		XCTAssertNil(extractVariables(from: "/some/path?min=1&mux=2", matching: "/some/path?min={min}&max={max}"))
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
