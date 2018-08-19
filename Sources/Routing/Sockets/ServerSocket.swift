import HTTP

public protocol ServerSocket {
	associatedtype ClientSocket: Routing.ClientSocket
	func nextClient() throws -> ClientSocket
	func close()
}
