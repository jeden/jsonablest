//
//  DecodingTests.swift
//  Jsonablest
//
//  Created by Antonio Bello on 11/3/16.
//
//

import XCTest
import Jsonablest

class DecodingTests: XCTestCase {
	func testDecodeWithNonNilOptionals() {
		let dict: JsonDictionary = [ "optional": 1 ]
		let instance = StructWithOptionals.jsonDecode(dict)
		XCTAssertNotNil(instance)
		XCTAssertEqual(instance?.optional, 1)
	}

	func testDecodeWithNilOptionals() {
		let dict: JsonDictionary = [ : ]
		let instance = StructWithOptionals.jsonDecode(dict)
		XCTAssertNotNil(instance)
		XCTAssertEqual(instance?.optional, nil)
	}
}


private struct DecodableStruct {
	let number: Int
	let float: Float
	let double: Double
	let string: String
}

extension DecodableStruct : JsonDecodable {
	static func jsonDecode(_ json: JsonType) -> DecodableStruct? {
		return .none
	}
}

private struct StructWithOptionals {
	let optional: Int?
}

extension StructWithOptionals : JsonDecodable {
	static func jsonDecode(_ json: JsonType) -> StructWithOptionals? {
		guard let dict = json as? JsonDictionary else { return nil }
		return self.init <^> dict["optional"] >>> JsonInt
	}
}
