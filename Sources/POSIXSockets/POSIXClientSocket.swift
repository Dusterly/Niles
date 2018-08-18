import Foundation
import Routing

public struct POSIXClientSocket {
	let raw: RawSocket
}

extension POSIXClientSocket: ClientSocket {
	public func data(readingLength length: Int) throws -> Data {
		if length == 0 { return Data() }

		var buffer = [UInt8](repeating: 0, count: length)
		let actualCount = try raw.receive(&buffer)
		return Data(bytes: buffer, count: actualCount)
	}

	public func write(_ data: Data) throws {
		let bytes = Array(data)
		try bytes.withUnsafeBufferPointer {
			try raw.send($0)
		}
	}

	public func close() {
		raw.close()
	}
}
