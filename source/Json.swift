//
//  Json.swift
//  Jsonablest
//
//  Created by Antonio Bello on 8/12/14.
//  Copyright (c) 2015 Elapsus. All rights reserved.
//
//  Released under the MIT license. See the LICENSE file.

import Foundation

/// A generic JSON type
public typealias JsonType = Any

/// A JSON object containing (potentially nested) fields
public typealias JsonDictionary = Dictionary<String, JsonType>

/// An array of JsonType
public typealias JsonArray = Array<JsonType>

// MARK: - JsonDecodable

public protocol JsonDecodable {
	@available(iOS, deprecated: 9.4, renamed: "jsonDecode")
    static func decode(_ json: JsonType) -> Self?

	static func jsonDecode(_ json: JsonType) -> Self?
}

extension JsonDecodable {
	public static func decode(_ json: JsonType) -> Self? {
		return .none
	}
}

// MARK: - JsonEncodable

public protocol JsonEncodable {
	@available(iOS, deprecated: 9.4, renamed: "jsonEncode")
    func encode() -> JsonDictionary

	func jsonEncode() -> JsonDictionary
}

extension JsonEncodable {
	public func encode() -> JsonDictionary {
		return [:]
	}
}

/// When adopted, the type can specify a list of fields to be excluded by the
/// `exportJson()` method
public protocol JsonEncodingIgnorable {
	var jsonFieldIgnores: [String] { get }
}

public protocol JsonEncodingReplaceable {
	var jsonFieldReplacements: [String : String] { get }
}

extension JsonEncodable {
	/// Default implementation of the jsonEncode method()
	/// It loops through all type fields, which are not included in the optional
	/// list of fields specified via the `JsonEncodingIgnorable` interface, and export
	/// as a `JsonDictionary`
	public func jsonEncode() -> JsonDictionary {
		var dict: JsonDictionary = [:]
		let ignoreList: Set<String>
		let replacementList: [String : String]

		if let ignorable = self as? JsonEncodingIgnorable {
			ignoreList = Set<String>(ignorable.jsonFieldIgnores)
		} else {
			ignoreList = Set<String>()
		}

		if let replaceable = self as? JsonEncodingReplaceable {
			replacementList = replaceable.jsonFieldReplacements
		} else {
			replacementList = [:]
		}

		let mirror = Mirror(reflecting: self)
		for child in mirror.children {
			guard let label = child.label else { continue }
			guard ignoreList.contains(label) == false else { continue }
			let key = replacementList[label] ?? label

			let value: Any? = {
				let mirror = Mirror(reflecting: child.value)
				guard mirror.displayStyle == .optional else { return child.value }
				guard let (_, first) = mirror.children.first else { return nil }
				return first
			}()

			switch value {
			case .none: break
			case let value as JsonEncodable:
				dict[key] = value.jsonEncode() as JsonType?
			case let value as Date:
				dict[key] = value.toIso8610()
			case let value:
				dict[key] = value
			}
		}

		return dict
	}
}

// MARK: - Types

public func JsonString(_ object: JsonType?) -> String? { return object as? String }
public func JsonInt(_ object: JsonType?) -> Int? { return object as? Int }
public func JsonFloat(_ object: JsonType?) -> Float? { return object as? Float }
public func JsonDouble(_ object: JsonType?) -> Double? { return object as? Double }
public func JsonBool(_ object: JsonType?) -> Bool? { return object as? Bool }
public func JsonDate(_ object: JsonType?) -> Date? {
	switch object {
	case let date as Date:
		return date
	case let date as String:
		return Date.dateFromIso8610(date)
	default:
		return .none
	}
}
public func JsonObject(_ object: JsonType?) -> JsonDictionary? { return object as? JsonDictionary }
public func JsonList<T>(_ list: JsonType?) -> [T]? { return list as? [T] }
public func JsonList<T: JsonDecodable>(_ list: JsonType?) -> [T]? {
	if let list = list as? JsonArray {
		var array = [T]()
		for listElement in list {
			if let element = T.jsonDecode(listElement) {
				array.append(element)
			}
		}
		return array
	}
	return .none
}
public func JsonEntity<T: JsonDecodable>(_ object: JsonType?) -> T? {
	if let object: JsonType = object {
		return T.jsonDecode(object)
	}
	return .none
}

#if os(iOS)

import UIKit

public func JsonColor(_ color: JsonType?) -> UIColor? {
	guard let color = color as? String else { return .none }
	return UIColor(hexColor: color)
}

private extension UIColor {
	convenience init?(hexColor: String) {
		let color: NSMutableString = NSMutableString(string: hexColor)
		color.replaceOccurrences(of: "#", with: "", options: [], range: NSRange(location: 0, length: color.length))
		if color.length == 6 {
			color.append("FF")
		}
		guard color.length == 8 else { return nil }

		let scanner = Scanner(string: color as String)
		var hex: UInt64 = 0

		guard scanner.scanHexInt64(&hex) else { return nil }
		let hexColor = UInt32(hex)
		self.init(color: hexColor)
	}
	convenience init(color: UInt32) {
		let red = (color >> 24) & 0xFF
		let green = (color >> 16) & 0xFF
		let blue = (color >> 8) & 0xFF
		let alpha = (color >> 0) & 0xFF

		self.init(red: (CGFloat(red) / 255.0), green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
	}
}

#endif

infix operator >>> : MultiplicationPrecedence
public func >>> <A, B>(a: A?, f: (A) -> B?) -> B? {
    if let x = a {
        return f(x)
    }
    return .none
}


infix operator <^>: AdditionPrecedence
public func <^> <A, B>(f: (A) -> B, a: A?) -> B? {
    if let x = a {
        return f(x)
    }
    return .none
}

public func <^> <A, B>(f: (A?) -> B, a: A?) -> B {
	return f(a)
}

infix operator <&&>: AdditionPrecedence
public func <&&> <A, B>(f: ((A) -> B)?, a: A?) -> B? {
    if let x = a {
        if let fx = f {
            return fx(x)
        }
    }
    return .none
}

infix operator <||>: AdditionPrecedence
public func <||> <A, B>(f: ((A?) -> B)? , a: A?) -> B? {
    if let fx = f {
        return fx(a != nil ? a : .none)
    }
    return .none
}
