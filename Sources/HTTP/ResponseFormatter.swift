public class ResponseFormatter {
	private let httpVersion: String

	public init(httpVersion: String) {
		self.httpVersion = httpVersion
	}

	public func response() -> String {
		return "\(httpVersion) "
	}
}
