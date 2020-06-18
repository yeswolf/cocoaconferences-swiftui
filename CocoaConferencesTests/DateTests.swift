//
// Created by jetbrains on 18.06.2020.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import XCTest
import CCLibrary
import Yams
@testable import CocoaConferences

class DateTests: XCTestCase {
    let decoder = YAMLDecoder()

    func testSameStartEndDateShownCorrectly() {
        let yaml = try! decoder.decode([Conference].self, from:
        """
        - name: mDevCamp
          link: https://mdevcamp.eu/
          start: 2019-05-30
          end: 2019-05-30
          location: 🇨🇿 Prague, Czech Republic
          cocoa-only: true
        """
        )
        let conference: Conference = yaml[0]
        XCTAssertEqual(conference.textDates(), "🗓 May 30, 2019")

    }

    func testDateWithoutEndShownCorrectly() {
        let yaml = try! decoder.decode([Conference].self, from:
        """
        - name: mDevCamp
          link: https://mdevcamp.eu/
          start: 2019-05-30
          location: 🇨🇿 Prague, Czech Republic
          cocoa-only: false
        """
        )
        let conference: Conference = yaml[0]
        XCTAssertEqual(conference.textDates(), "🗓 May 30, 2019")
    }

    func testEndEarlierThanStartReplaced() {
        let yaml = try! decoder.decode([Conference].self, from:
        """
        - name: mDevCamp
          link: https://mdevcamp.eu/
          start: 2019-05-30
          end: 2019-05-29
          location: 🇨🇿 Prague, Czech Republic
          cocoa-only: false
        """
        )
        let conference: Conference = yaml[0]
        XCTAssertEqual(conference.textDates(), "🗓 May 29, 2019 - May 30, 2019")
    }

}
