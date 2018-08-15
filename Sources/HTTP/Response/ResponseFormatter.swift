import Foundation

public class ResponseFormatter {
	private let httpVersion: String

	public init(httpVersion: String) {
		self.httpVersion = httpVersion
	}

	public func write(response: Response, to output: DataWritable) {
		output.writeLine("\(httpVersion) \(response.statusCode.rawValue)")

		let headers = response.headersAddingContentLength
		for (header, value) in headers {
			output.writeLine("\(header): \(value)")
		}
		output.writeLine()

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
	func writeLine(_ line: String = "") {
		write("\(line)\r\n")
	}

	func write(_ string: String) {
		guard let data = string.data(using: .ascii) else { return }
		write(data)
	}
}
