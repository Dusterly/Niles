import Foundation

extension SocketDescriptor {
	func send(_ buffer: UnsafeBufferPointer<UInt8>) throws {
		guard let baseAddress = buffer.baseAddress else { throw SocketError.noStream }
		let sent = try attempt {
			Foundation.send(rawValue, baseAddress, buffer.count, 0)
		}
		guard sent == buffer.count else { throw SocketError.noStream }
	}

	func receive(_ buffer: inout [UInt8]) throws -> Int {
		let actualCount =  try attempt {
			Foundation.recv(rawValue, &buffer, buffer.count, 0)
		}
		guard actualCount > 0 else { throw SocketError.noStream }
		return actualCount
	}
}
