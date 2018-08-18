import Foundation
import Routing

public typealias InetPort = UInt16

public struct POSIXServerSocket {
	fileprivate let raw: RawSocket

	public init(listeningOn port: InetPort = 80, maxPendingConnections: Int32 = SOMAXCONN) throws {
		raw = try RawSocket.ipv6()

		do {
			try acquire(port: port)
			try raw.listen(maxPendingConnections: maxPendingConnections)
		} catch let error {
			raw.close()
			throw error
		}
	}
}

extension POSIXServerSocket: ServerSocket {
	public func nextClient() throws -> POSIXClientSocket {
		let clientSocket: RawSocket = try raw.accept()
		return POSIXClientSocket(raw: clientSocket)
	}

	public func close() {
		raw.close()
	}
}

private extension POSIXServerSocket {
	func acquire(port: InetPort) throws {
		let localhost = sockaddr_in6(localhostAt: port)
		try raw.acquire(address: localhost)
	}
}

private extension sockaddr_in6 {
	init(localhostAt port: InetPort) {
		self.init()
		self.sin6_family = sa_family_t(AF_INET6)
		self.sin6_port = port.bigEndian
	}
}
