//
//  JsonDate.swift
//  Jsonablest
//
//  Created by Antonio Bello on 8/14/14.
//  Copyright (c) 2015 Elapsus. All rights reserved.
//
//  Released under the MIT license. See the LICENSE file.

import Foundation

extension Date {
	fileprivate static var dateFormatter: DateFormatter {
		let iso8610DateFormatter = DateFormatter()
		iso8610DateFormatter.timeStyle = .full
		iso8610DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
		iso8610DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		return iso8610DateFormatter
	}

    public static func dateFromIso8610(_ jsonDate: String?) -> Date? {
        if let jsonDate = jsonDate {
            return self.dateFormatter.date(from: jsonDate)
        }

        return .none
    }

	public func toIso8610() -> String {
		return Date.dateFormatter.string(from: self)
	}
}
