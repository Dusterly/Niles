public protocol Response {
	var statusCode: StatusCode { get }
	var headers: [String: String] { get }
}
