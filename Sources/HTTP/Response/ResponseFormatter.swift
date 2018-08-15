import Foundation

public class ResponseFormatter {
	private let httpVersion: String

	public init(httpVersion: String) {
		self.httpVersion = httpVersion
	}

	public func write(response: Response, to output: DataWritable) {
		output.write("\(httpVersion) \(response.statusCode.rawValue)\n")
		for (header, value) in response.headers {
			output.write("\(header): \(value)")
		}
	}
}

private extension DataWritable {
	func write(_ string: String) {
		guard let data = string.data(using: .ascii) else { return }
		write(data)
	}
}
