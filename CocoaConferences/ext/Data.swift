//
// Created by jetbrains on 15.11.2019.
// Copyright (c) 2019 JetBrains. All rights reserved.
//

import Foundation

extension Date {
    public func friendly() -> String {
        let format = DateFormatter()
        format.dateFormat = "MMMM dd, yyyy"
        format.locale = Locale(identifier: "en_US_POSIX")
        return format.string(from: self)
    }
}

extension String {
    public func date() -> Date {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.locale = Locale(identifier: "en_US_POSIX")
        let result = format.date(from: self)!
        var comps =
                Calendar.current.dateComponents([.year, .month, .day], from: result)
        comps.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar.current.date(from: comps)!
    }
}
