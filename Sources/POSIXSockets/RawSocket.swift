import Foundation

struct RawSocket {
	let descriptor: Int32
}

@discardableResult
func attempt<IntN: BinaryInteger>(_ call: () -> IntN) throws -> IntN {
		let result = call()
		guard result > -1 else { throw SocketError.withDescription(lastErrorMessage) }
		return result
}

var lastErrorMessage: String {
	var defaultDescription: String { return "Error: \(errno)" }

	guard let cString = strerror(errno) else { return defaultDescription }
	return String(cString: cString, encoding: .ascii) ?? defaultDescription
}

enum SocketError: Error {
	case noStream
	case withDescription(String)
}

func socklen<T>(_ value: T) -> socklen_t {
	return socklen_t(MemoryLayout.size(ofValue: value))
}

func withUnsafePointer<T, U, Result>(
	to value: inout T,
	reboundTo type: U.Type,
	capacity: Int = 1,
	call: @escaping (UnsafePointer<U>) -> Result
) -> Result {
	return withUnsafePointer(to: &value) {
		$0.withMemoryRebound(to: type, capacity: capacity, call)
	}
}
