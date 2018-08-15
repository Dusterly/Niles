import Foundation

public protocol Response {
	var statusCode: StatusCode { get }
	var headers: [String: String] { get }
	var body: Data? { get }
}
