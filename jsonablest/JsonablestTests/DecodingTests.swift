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

	func testDecodeHEXColorWithoutAlpha() {
		let dict: JsonDictionary = [ "color": "A08830"]
		let expectedColor = UIColor(red: 160/255, green: 136/255, blue: 48/255, alpha: 255/255)
		let instance = StructWithColor.jsonDecode(dict)
		XCTAssertNotNil(instance)
		XCTAssertEqual(instance?.color, expectedColor)
	}

	func testDecodeHEXColorWithAlpha() {
		let dict: JsonDictionary = [ "color": "A088307F"]
		let expectedColor = UIColor(red: 160/255, green: 136/255, blue: 48/255, alpha: 127/255)
		let instance = StructWithColor.jsonDecode(dict)
		XCTAssertNotNil(instance)
		XCTAssertEqual(instance?.color, expectedColor)
	}

	func testDecodeHEXColorWithPrefix() {
		let dict: JsonDictionary = [ "color": "#A08830"]
		let expectedColor = UIColor(red: 160/255, green: 136/255, blue: 48/255, alpha: 255/255)
		let instance = StructWithColor.jsonDecode(dict)
		XCTAssertNotNil(instance)
		XCTAssertEqual(instance?.color, expectedColor)
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

private struct StructWithColor {
	let color: UIColor
}

extension StructWithColor : JsonDecodable {
	static func jsonDecode(_ json: JsonType) -> StructWithColor? {
		guard let dict = json as? JsonDictionary else { return nil }
		return self.init <^> dict["color"] >>> JsonColor
	}
}
