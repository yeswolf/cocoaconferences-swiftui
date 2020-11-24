//
// Created by jetbrains on 11/16/20.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import Combine

class Filter {
    var start: Date = Date()
    var end: Date = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    var cfpOpened: Bool = false
    var asc: Bool = false

    init(start: Date, end: Date, cfpOpened: Bool, asc: Bool) {
        self.start = start
        self.end = end
        self.cfpOpened = cfpOpened
        self.asc = asc
    }

    init() {

    }
}