//
//  JsonCocoa.swift
//  Jsonablest
//
//  Created by Antonio Bello on 2/29/16.
//  Copyright (c) 2015 Elapsus. All rights reserved.
//
//  Released under the MIT license. See the LICENSE file.

// private extension UIColor {
// 	convenience init(hexColor color: UInt32) {
// 		let red = (color >> 16) & 0xFF
// 		let green = (color >> 8) & 0xFF
// 		let blue = color & 0xFF
//
// 		self.init(red: (CGFloat(red) / 256.0), green: CGFloat(green) / 256.0, blue: CGFloat(blue) / 256.0, alpha: 1.0)
// 	}
// }
//
// public func CocoaColor(object: JsonType?) -> UIColor? {
// 	guard let color = object as? Int else { return .none }
// 	let hexColor = UInt32(color)
// 	return UIColor(hexColor: hexColor)
// }

public func CocoaUrl(object: JsonType?) -> NSURL? {
	guard let url = object as? String else { return .none }
	return NSURL(string: url)
}
