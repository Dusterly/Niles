import Foundation

public protocol DataReadable {
	func data(readingLength count: Int) throws -> Data
}
