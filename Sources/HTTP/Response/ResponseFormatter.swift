import Foundation

public class ResponseFormatter {
	private let httpVersion: String

	public init(httpVersion: String) {
		self.httpVersion = httpVersion
	}

	public func write(response: Response, to output: DataWritable) {
		var headers = response.headers

		if let body = response.body, headers["Content-Length"] == nil {
			headers["Content-Length"] = "\(body.count)"
		}

		output.write("\(httpVersion) \(response.statusCode.rawValue)\n")
		for (header, value) in headers {
			output.write("\(header): \(value)\n")
		}

		if let body = response.body {
			output.write("\r\n")
			output.write(body)
		}
	}
}

private extension DataWritable {
	func write(_ string: String) {
		guard let data = string.data(using: .ascii) else { return }
		write(data)
	}
}
