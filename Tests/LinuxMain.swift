import XCTest

import HTTPTests
import RoutingTests

let allTestSuites = [
	HTTPTests.allTests(),
	RoutingTests.allTests(),
]

XCTMain(allTestSuites.flatMap { $0 })
