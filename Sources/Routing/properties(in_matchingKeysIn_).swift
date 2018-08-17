import Foundation

private let regex = try! NSRegularExpression(pattern: "\\{(.*?)\\}|[^{}]+")

public func properties(in path: String, matchingKeysIn pattern: String) -> [String: String]? {
	var properties: [String: String] = [:]

	let matches = regex.matches(in: pattern, range: NSRange(pattern.startIndex..., in: pattern))
	let matches0 = matches.map { (it: NSTextCheckingResult) -> Match in
		var groupRanges: [Range<String.Index>?] = []
		for i in 0..<it.numberOfRanges { groupRanges.append(it.range(at: i, in: pattern)) }
		let entireRange = it.range(in: pattern)!
		return Match(
			entireRange: entireRange,
			groupRanges: groupRanges,
			entireMatch: String(pattern[entireRange]),
			groups: groupRanges.map({ if let it = $0 { return String(pattern[it]) } else { return nil } })
		)
	}

	var currentPathIndex = path.startIndex
	for (match, next) in zip(matches0, matches0.dropFirst()) {
		if let key = match.groups[1] {
			guard let nextIndex = path.range(of: next.entireMatch, range: currentPathIndex..<path.endIndex)?.lowerBound else { return nil }

			let value = String(path[currentPathIndex..<nextIndex])
			properties[key] = value
		} else {
			let textRange = match.entireRange
			guard let range = path.range(of: pattern[textRange], range: currentPathIndex..<path.endIndex) else { return nil }
			currentPathIndex = range.upperBound
		}
	}

	let match = matches0.last!

	if let key = match.groups[1] {
		let value = String(path[currentPathIndex...])
		properties[key] = value
	} else {
		let textRange = match.entireRange
		if path.range(of: pattern[textRange], range: currentPathIndex..<path.endIndex) == nil { return nil }
	}

	return properties
}

private struct Match {
	var entireRange: Range<String.Index>
	var groupRanges: [Range<String.Index>?]

	var entireMatch: String
	var groups: [String?]
}

private extension NSTextCheckingResult {
	func range(in string: String) -> Range<String.Index>? {
		return Range(range, in: string)
	}

	func range(at index: Int, in string: String) -> Range<String.Index>? {
		return Range(range(at: index), in: string)
	}
}
