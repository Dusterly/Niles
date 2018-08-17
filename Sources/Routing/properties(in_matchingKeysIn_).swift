import Foundation

public func properties(in path: String, matchingKeysIn pattern: String) -> [String: String]? {
	var properties: [String: String] = [:]
	var currentPathIndex = path.startIndex

	let components = Routing.components(in: pattern)
	let endIndexFinders: [() -> String.Index?] = components.dropFirst().map { component in
		{ path.range(of: component.text, range: currentPathIndex..<path.endIndex)?.lowerBound }
	}

	for (component, findNextEndIndex) in zip(components, endIndexFinders + [ { path.endIndex }]) {
		if let key = component.key {
			guard let valueEndIndex = findNextEndIndex() else { return nil }
			let value = String(path[currentPathIndex..<valueEndIndex])
			properties[key] = value
		} else {
			guard let range = path.range(of: component.text, range: currentPathIndex..<path.endIndex) else { return nil }
			currentPathIndex = range.upperBound
		}
	}

	return properties
}

private func components(in pattern: String) -> [Component] {
	let regex = try! NSRegularExpression(pattern: "\\{(.*?)\\}|[^{}]+")
	return regex.matches(in: pattern).map {
		Component(
			text: String(pattern[$0.range(in: pattern)!]),
			key: $0.range(at: 1, in: pattern).flatMap { String(pattern[$0]) }
		)
	}
}

private struct Component {
	var text: String
	var key: String?
}

private extension NSRegularExpression {
	func matches(in string: String) -> [NSTextCheckingResult] {
		return matches(in: string, range: string.startIndex..<string.endIndex)
	}

	func matches(in string: String, range: Range<String.Index>) -> [NSTextCheckingResult] {
		return matches(in: string, range: NSRange(range, in: string))
	}
}

private extension NSTextCheckingResult {
	func range(in string: String) -> Range<String.Index>? {
		return Range(range, in: string)
	}

	func range(at index: Int, in string: String) -> Range<String.Index>? {
		return Range(range(at: index), in: string)
	}
}
