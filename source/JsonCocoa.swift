//
// Created by Antonio Bello on 2/29/16.
// Copyright (c) 2016 vida.watch LLC. All rights reserved.
//

import Foundation

public func CocoaColor(object: JsonType?) -> UIColor? {
	guard let color = object as? Int else { return .None }
	let hexColor = UInt32(color)
	return UIColor(color: hexColor)
}

public func CocoaUrl(object: JsonType?) -> NSURL? {
	guard let url = object as? String else { return .None }
	return NSURL(string: url)
}