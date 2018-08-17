import Foundation

private let regex = try! NSRegularExpression(pattern: "\\{(.*?)\\}|[^{}]+")

public func extractVariables(from path: String, matching pattern: String) -> [String: String]? {
	var variables: [String: String] = [:]

	let matches = regex.matches(in: pattern, range: NSRange(pattern.startIndex..., in: pattern))

	var currentPathIndex = path.startIndex
	for (match, next) in zip(matches, matches.dropFirst()) {
		if let keyRange = Range(match.range(at: 1), in: pattern) {
			let key = String(pattern[keyRange])

			guard let nextIndex = path.range(of: pattern[Range(next.range, in: pattern)!], range: currentPathIndex..<path.endIndex)?.lowerBound else { return nil }

			let value = String(path[currentPathIndex..<nextIndex])
			variables[key] = value
		} else {
			let textRange = Range(match.range, in: pattern)!
			guard let range = path.range(of: pattern[textRange], range: currentPathIndex..<path.endIndex) else { return nil }
			currentPathIndex = range.upperBound
		}
	}

	let match = matches.last!

	if let keyRange = Range(match.range(at: 1), in: pattern) {
		let key = String(pattern[keyRange])
		let value = String(path[currentPathIndex...])
		variables[key] = value
	} else {
		let textRange = Range(match.range, in: pattern)!
		if path.range(of: pattern[textRange], range: currentPathIndex..<path.endIndex) == nil { return nil }
	}

	return variables
}
