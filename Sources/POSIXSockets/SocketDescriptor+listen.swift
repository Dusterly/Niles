import Foundation

#if !os(macOS)
// swiftlint:disable identifier_name
let SOCK_STREAM = Int32(Foundation.SOCK_STREAM.rawValue)
// swiftlint:enable identifier_name
#endif

extension SocketDescriptor {
	static func ipv6() throws -> SocketDescriptor {
		let fileDescriptor = try attempt {
			Foundation.socket(AF_INET6, SOCK_STREAM, 0)
		}

		var value: Int32 = 1
		try attempt {
			Foundation.setsockopt(fileDescriptor, SOL_SOCKET, SO_REUSEADDR, &value, socklen(value))
		}

		return SocketDescriptor(rawValue: fileDescriptor)
	}

	func acquire(address: sockaddr_in6) throws {
		var address = address
		let len = socklen(address)
		try attempt {
			withUnsafePointer(to: &address, reboundTo: sockaddr.self) {
				Foundation.bind(self.rawValue, $0, len)
			}
		}
	}

	func listen(maxPendingConnections: Int32) throws {
		try attempt {
			Foundation.listen(rawValue, maxPendingConnections)
		}
	}

	func accept() throws -> SocketDescriptor {
		let clientDescriptor = try attempt { Foundation.accept(rawValue, nil, nil) }
		return SocketDescriptor(rawValue: clientDescriptor)
	}

	func close() {
		_ = Foundation.close(rawValue)
	}
}
