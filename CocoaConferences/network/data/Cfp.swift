//
// Created by jetbrains on 2019-01-18.
// Copyright (c) 2019 JetBrains. All rights reserved.
//

import Foundation
import Yams

class Cfp: Codable {

    var link: String //https://goo.gl/forms/eoX2WfG1LRoZPxxo1
    var deadline: Date? //2019-02-28

    init() {
        link = ""
        deadline = nil
    }
}
