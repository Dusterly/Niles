import Foundation
import Routing

public typealias InetPort = UInt16

public struct POSIXServerSocket {
	public let descriptor: SocketDescriptor

	public init(listeningOn port: InetPort = 80, maxPendingConnections: Int32 = SOMAXCONN) throws {
		descriptor = try SocketDescriptor.ipv6()

		do {
			try acquire(port: port)
			try descriptor.listen(maxPendingConnections: maxPendingConnections)
		} catch let error {
			descriptor.close()
			throw error
		}
	}
}

extension POSIXServerSocket: ServerSocket {
	public func nextClient() throws -> POSIXClientSocket {
		let clientSocket: SocketDescriptor = try descriptor.accept()
		return POSIXClientSocket(descriptor: clientSocket)
	}

	public func close() {
		descriptor.close()
	}
}

private extension POSIXServerSocket {
	func acquire(port: InetPort) throws {
		let localhost = sockaddr_in6(localhostAt: port)
		try descriptor.acquire(address: localhost)
	}
}

private extension sockaddr_in6 {
	init(localhostAt port: InetPort) {
		self.init()
		self.sin6_family = sa_family_t(AF_INET6)
		self.sin6_port = port.bigEndian
	}
}
