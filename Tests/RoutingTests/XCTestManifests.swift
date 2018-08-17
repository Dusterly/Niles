import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
	return [
		testCase(PathVariablesTests.allTests),
		testCase(RouterTests.allTests),
	]
}
#endif
