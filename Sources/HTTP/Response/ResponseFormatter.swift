import Foundation

public class ResponseFormatter {
	private let httpVersion: String

	public init(httpVersion: String) {
		self.httpVersion = httpVersion
	}

	public func write(response: Response, to output: DataWritable) {
		output.write("\(httpVersion) \(response.statusCode.rawValue)\r\n")

		let headers = response.headersAddingContentLength
		for (header, value) in headers {
			output.write("\(header): \(value)\n")
		}
		output.write("\r\n")

		if let body = response.body {
			output.write(body)
		}
	}
}

private extension Response {
	var headersAddingContentLength: [String: String] {
		guard let body = body else { return headers }
		if headers["Content-Length"] != nil { return headers }

		var modifiedHeaders = headers
		modifiedHeaders["Content-Length"] = "\(body.count)"
		return modifiedHeaders
	}
}

private extension DataWritable {
	func write(_ string: String) {
		guard let data = string.data(using: .ascii) else { return }
		write(data)
	}
}
