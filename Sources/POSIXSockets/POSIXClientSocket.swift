import Foundation
import Routing

public struct POSIXClientSocket {
	public let descriptor: SocketDescriptor
}

extension POSIXClientSocket: ClientSocket {
	public func data(readingLength length: Int) throws -> Data {
		if length == 0 { return Data() }

		var buffer = [UInt8](repeating: 0, count: length)
		let actualCount = try descriptor.receive(&buffer)
		return Data(bytes: buffer, count: actualCount)
	}

	public func write(_ data: Data) throws {
		let bytes = Array(data)
		try bytes.withUnsafeBufferPointer {
			try descriptor.send($0)
		}
	}

	public func close() {
		descriptor.close()
	}
}
