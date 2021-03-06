// swiftlint:disable identifier_name

public enum StatusCode: String {
	// Source: https://httpstatuses.com

	// 1×× Informational
	case `continue` = "100 Continue"
	case switchingProtocols = "101 Switching Protocols"
	case processing = "102 Processing"

	// 2×× Success
	case ok = "200 OK"
	case created = "201 Created"
	case accepted = "202 Accepted"
	case nonAuthoritativeInformation = "203 Non-authoritative Information"
	case noContent = "204 No Content"
	case resetContent = "205 Reset Content"
	case partialContet = "206 Partial Content"
	case multiStatus = "207 Multi-Status"
	case alreadyReported = "208 Already Reported"
	case imUsed = "226 IM Used"

	// 3×× Redirection
	case multipleChoices = "300 Multiple Choices"
	case movedPermanently = "301 Moved Permanently"
	case found = "302 Found"
	case seeOther = "303 See Other"
	case notModified = "304 Not Modified"
	case useProxy = "305 Use Proxy"
	case temporaryRedirect = "307 Temporary Redirect"
	case permanentRedirect = "308 Permanent Redirect"

	// 4×× Client Error"
	case badRequest = "400 Bad Request"
	case unauthorized = "401 Unauthorized"
	case paymentRequired = "402 Payment Required"
	case forbidden = "403 Forbidden"
	case notFound = "404 Not Found"
	case methodNotAllowed = "405 Method Not Allowed"
	case notAcceptable = "406 Not Acceptable"
	case proxyAuthenticationRequired = "407 Proxy Authentication Required"
	case requestTimeout = "408 Request Timeout"
	case conflict = "409 Conflict"
	case gone = "410 Gone"
	case lengthRequired = "411 Length Required"
	case preconditionFailed = "412 Precondition Failed"
	case payloadTooLarge = "413 Payload Too Large"
	case requestURITooLong = "414 Request-URI Too Long"
	case unsupportedMediaType = "415 Unsupported Media Type"
	case requestedRangeNotSatisfiable = "416 Requested Range Not Satisfiable"
	case expectationFailed = "417 Expectation Failed"
	case imATeapot = "418 I'm a teapot"
	case misdirectedRequest = "421 Misdirected Request"
	case unprocessableEntity = "422 Unprocessable Entity"
	case locked = "423 Locked"
	case failedDependency = "424 Failed Dependency"
	case upgradeRequired = "426 Upgrade Required"
	case preconditionRequired = "428 Precondition Required"
	case tooManyRequests = "429 Too Many Requests"
	case requestHeaderFieldsTooLarge = "431 Request Header Fields Too Large"
	case connectionClosedWithoutResponse = "444 Connection Closed Without Response"
	case unavailableForLegalReasons = "451 Unavailable For Legal Reasons"
	case clientClosedRequest = "499 Client Closed Request"

	// 5×× Server Error
	case internalServerError = "500 Internal Server Error"
	case notImplemented = "501 Not Implemented"
	case badGateway = "502 Bad Gateway"
	case serviceUnavailable = "503 Service Unavailable"
	case gatewayTimeout = "504 Gateway Timeout"
	case httpVersionNotSupported = "505 HTTP Version Not Supported"
	case variantAlsoNegotiates = "506 Variant Also Negotiates"
	case insufficientStorage = "507 Insufficient Storage"
	case loopDetected = "508 Loop Detected"
	case notExtended = "510 Not Extended"
	case networkAuthenticationRequired = "511 Network Authentication Required"
	case networkConnectTimeoutError = "599 Network Connect Timeout Error"
}

public extension StatusCode {
	var isError: Bool {
		return rawValue.hasPrefix("4") || rawValue.hasPrefix("5")
	}
}
