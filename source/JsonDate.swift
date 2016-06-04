//
//  JsonDate.swift
//  Jsonablest
//
//  Created by Antonio Bello on 8/14/14.
//  Copyright (c) 2015 Elapsus. All rights reserved.
//
//  Released under the MIT license. See the LICENSE file.

import Foundation

extension NSDate {
	private static var dateFormatter: NSDateFormatter {
		let iso8610DateFormatter = NSDateFormatter()
		iso8610DateFormatter.timeStyle = .FullStyle
		iso8610DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
		iso8610DateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
		return iso8610DateFormatter
	}

    public static func dateFromIso8610(jsonDate: String?) -> NSDate? {
        if let jsonDate = jsonDate {
            return self.dateFormatter.dateFromString(jsonDate)
        }

        return .None
    }

	public func toIso8610() -> String {
		return NSDate.dateFormatter.stringFromDate(self)
	}
}
