//
//  Json.swift
//  Jsonablest
//
//  Created by Antonio Bello on 8/12/14.
//  Copyright (c) 2015 Elapsus. All rights reserved.
//
//  Released under the MIT license. See the LICENSE file.

import Foundation

public typealias JsonType = AnyObject
public typealias JsonDictionary = Dictionary<String, JsonType>
public typealias JsonArray = Array<JsonType>

public protocol JsonDecodable {
    static func decode(json: JsonType) -> Self?
}

public protocol JsonEncodable {
    func encode() -> JsonDictionary
}

public func JsonString(object: JsonType?) -> String? { return object as? String }
public func JsonInt(object: JsonType?) -> Int? { return object as? Int }
public func JsonBool(object: JsonType?) -> Bool? { return object as? Bool }
public func JsonDate(object: JsonType?) -> NSDate? { return NSDate.dateFromIso8610(JsonString(object)) }
public func JsonObject(object: JsonType?) -> JsonDictionary? { return object as? JsonDictionary }
public func JsonEntity<T: JsonDecodable>(object: JsonType?) -> T? {
    if let object: JsonType = object {
        return T.decode(object)
    }
    return .None
}
public func JsonList<T: JsonDecodable>(list: JsonType?) -> [T]? {
	if let list = list as? JsonArray {
		var array = [T]()
		for listElement in list {
			if let element = T.decode(listElement) {
				array.append(element)
			}
		}
		return array
	}
	return .None
}

infix operator >>> { associativity left precedence 150 }
public func >>> <A, B>(a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x)
    }
    return .None
}


infix operator <^> { associativity left precedence 140 }
public func <^> <A, B>(f: A -> B, a: A?) -> B? {
    if let x = a {
        return f(x)
    }
    return .None
}


infix operator <&&> { associativity left precedence 140 }
public func <&&> <A, B>(f: (A -> B)?, a: A?) -> B? {
    if let x = a {
        if let fx = f {
            return fx(x)
        }
    }
    return .None
}

infix operator <||> { associativity left }
public func <||> <A, B>(f: (A? -> B)? , a: A?) -> B? {
    if let fx = f {
        return fx(a != nil ? a : .None)
    }
    return .None
}
