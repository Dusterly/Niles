import Foundation

#if !os(macOS)
// swiftlint:disable identifier_name
let SOCK_STREAM = Int32(Foundation.SOCK_STREAM.rawValue)
// swiftlint:enable identifier_name
#endif

extension RawSocket {
	static func ipv6() throws -> RawSocket {
		let fileDescriptor = try attempt {
			Foundation.socket(AF_INET6, SOCK_STREAM, 0)
		}

		var value: Int32 = 1
		try attempt {
			Foundation.setsockopt(fileDescriptor, SOL_SOCKET, SO_REUSEADDR, &value, socklen(value))
		}

		return RawSocket(descriptor: fileDescriptor)
	}

	func acquire(address: sockaddr_in6) throws {
		var address = address
		let len = socklen(address)
		try attempt {
			withUnsafePointer(to: &address, reboundTo: sockaddr.self) {
				Foundation.bind(self.descriptor, $0, len)
			}
		}
	}

	func listen(maxPendingConnections: Int32) throws {
		try attempt {
			Foundation.listen(self.descriptor, maxPendingConnections)
		}
	}

	func accept() throws -> RawSocket {
		let client = try attempt { Foundation.accept(descriptor, nil, nil) }
		return RawSocket(descriptor: client)
	}

	func close() {
		_ = Foundation.close(descriptor)
	}
}
