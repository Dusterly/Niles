public class ResponseFormatter {
	private let httpVersion: String

	public init(httpVersion: String) {
		self.httpVersion = httpVersion
	}

	public func output(response: Response) -> String {
		return "\(httpVersion) \(response.statusCode.rawValue)"
	}
}
