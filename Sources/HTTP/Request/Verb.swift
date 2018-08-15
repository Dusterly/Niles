public enum Verb: String {
	// Source: https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods

	case get     = "GET"     // download
	case head    = "HEAD"    // get headers, but not data

	case post    = "POST"    // add new
	case put     = "PUT"     // replace
	case patch   = "PATCH"   // modify partially

	case delete  = "DELETE"  // remove

	case connect = "CONNECT" // establish connection (e.g. TLS handshake)
	case options = "OPTIONS" // called by browsers to establish CORS
	case trace   = "TRACE"   // debugging call (used by trace-route I guess)
}
