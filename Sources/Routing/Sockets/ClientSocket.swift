import HTTP

public protocol ClientSocket: DataReadable, DataWritable {
	func close()
}
