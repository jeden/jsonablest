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
