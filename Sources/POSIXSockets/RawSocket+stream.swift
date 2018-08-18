import Foundation

extension RawSocket {
	func send(_ buffer: UnsafeBufferPointer<UInt8>) throws {
		guard let baseAddress = buffer.baseAddress else { throw SocketError.noStream }
		let sent = try attempt {
			Foundation.send(self.descriptor, baseAddress, buffer.count, 0)
		}
		guard sent == buffer.count else { throw SocketError.noStream }
	}

	func receive(_ buffer: inout [UInt8]) throws -> Int {
		let actualCount =  try attempt {
			Foundation.recv(self.descriptor, &buffer, buffer.count, 0)
		}
		guard actualCount > 0 else { throw SocketError.noStream }
		return actualCount
	}
}
