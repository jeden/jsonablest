//
//  EncodingTests.swift
//  EncodingTests
//
//  Created by Antonio Bello on 6/4/16.
//
//

import XCTest
import Jsonablest

class EncodingTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testAutomaticEncodeSuccess() {
		let expectedDictionary: JsonDictionary = [
			"oneString": "one",
			"twoInt": 2,
			"threeFloat": 3.0,
			"fourDouble": 4.0,
			"fiveBool": true
		]

		let structure = StructWithNoExplicitEncode(oneString: "one", twoInt: 2, threeFloat: 3.0, fourDouble: 4.0, fiveBool: true)

		let exportedDictionary = structure.jsonEncode()

		XCTAssert(exportedDictionary == expectedDictionary, "No match: \(exportedDictionary)")
	}

	func testAutomaticEncodeShouldFailWithWrongValue() {
		let value = SimpleInt(value: 1)
		let correctExpectation: JsonDictionary = ["value": 1]
		let wrongExpectation: JsonDictionary = [ "value": 2]

		let exported = value.jsonEncode()

		XCTAssert(correctExpectation == exported, "The actual json encoding doesn't match with the expected")
		XCTAssertFalse(wrongExpectation == exported, "the json encoding should be different than the expected wrong dictionary")
	}

	func testAutomaticEncodeWithEmbeddedJsonEncodables() {
		let embedded = SimpleInt(value: 10)
		let value = EmbeddingStruct(embedded: embedded)
		let expected: JsonDictionary = [
			"embedded": [
				"value": 10
			] as JsonType
		]
		let exported = value.jsonEncode()
		XCTAssert(expected == exported, "The generated json doens't match the expected one")
	}

	func testAutomaticEncodeWithIgnoredFields() {
		let value = FieldsWithIgnores(exported: "yes", ignored: true)
		let expected: JsonDictionary =  [
			"exported": "yes"
		]
		let exported = value.jsonEncode()
		XCTAssert(expected == exported, "The generated json doens't match the expected one")
	}
}

// MARK: Internal structures

/// A struct not having a jsonEncode() method, so using the default
// one implemented in the protocol extension
private struct StructWithNoExplicitEncode : JsonEncodable {
	let oneString : String
	let twoInt: Int
	let threeFloat: Float
	let fourDouble: Double
	let fiveBool: Bool
}

private struct SimpleInt : JsonEncodable {
	let value: Int
}

private struct EmbeddingStruct : JsonEncodable {
	let embedded: SimpleInt
}

private struct FieldsWithIgnores : JsonEncodable {
	let exported: String
	let ignored: Bool
}

extension FieldsWithIgnores : JsonEncodingIgnorable {
	var jsonIgnoreList : [String] {
		return ["ignored"]
	}
 }

private func == (op1: JsonDictionary, op2: JsonDictionary) -> Bool {
	return NSDictionary(dictionary: op1).isEqual(to: op2)
}
