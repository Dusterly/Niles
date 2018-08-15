public class ResponseFormatter {
	private let httpVersion: String

	public init(httpVersion: String) {
		self.httpVersion = httpVersion
	}

	public func output(response: Response) -> String {
		return "\(httpVersion) \(response.statusCode.rawValue) \(output(headers: response.headers))"
	}

	private func output(headers: [String: String]) -> String {
		var s = ""
		for (header, value) in headers {
			s += " \(header): \(value)"
		}
		return s
	}
}
