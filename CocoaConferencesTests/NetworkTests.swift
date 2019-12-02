//
//  CocoaConferencesTests.swift
//  CocoaConferencesTests
//
//  Created by jetbrains on 15.11.2019.
//  Copyright © 2019 JetBrains. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Yams
@testable import CocoaConferences

class NetworkTests: QuickSpec {
    override func spec() {
        super.spec()
        describe("API") {
            it("should load conference list") {
                waitUntil(timeout: 5) { done in
                    api.conferences { conferences in
                        expect(conferences).toNot(beEmpty())
                        expect(conferences.count).to(beGreaterThan(1))
                        expect(conferences[0].name).toNot(beEmpty())
                        done()
                    }
                }
            }
            it("should load conference without CFP") {
                let decoder = YAMLDecoder()
                let yaml = try! decoder.decode([Conference].self, from:
                """
                - name: mDevCamp
                  link: https://mdevcamp.eu/
                  start: 2019-05-30
                  end: 2019-05-31
                  location: 🇨🇿 Prague, Czech Republic
                  cocoa-only: false
                  cfp:
                    link: https://goo.gl/forms/eoX2WfG1LRoZPxxo1
                    deadline: 2019-02-28
                """
                )
                let conference: Conference = yaml[0]
                expect(conference.name).to(equal("mDevCamp"))
                expect(conference.start).to(equal( "2019-05-30".date()))
                expect(conference.end).to(equal( "2019-05-31".date()))
                expect(conference.cocoaOnly).to(equal(false))
                expect(conference.location).to(equal("🇨🇿 Prague, Czech Republic"))

                let cfp = Cfp()
                cfp.link = "https://goo.gl/forms/eoX2WfG1LRoZPxxo1"
                cfp.deadline = "2019-02-28".date()

                expect(conference.cfp!.link).to(equal(cfp.link))
                expect(conference.cfp!.deadline).to(equal(cfp.deadline))
            }
            it("should load conference with CFP") {
                let decoder = YAMLDecoder()
                let yaml = try! decoder.decode([Conference].self, from:
                """
                - name: mDevCamp
                  link: https://mdevcamp.eu/
                  start: 2019-05-30
                  end: 2019-05-31
                  location: 🇨🇿 Prague, Czech Republic
                  cocoa-only: false
                """
                )
                let conference = yaml[0]
                expect(conference.name).to(equal("mDevCamp"))
                expect(conference.start).to(equal("2019-05-30".date()))
                expect(conference.end).to(equal( "2019-05-31".date()))
                expect(conference.cocoaOnly).to(equal(false))
                expect(conference.location).to(equal("🇨🇿 Prague, Czech Republic"))
                expect(conference.cfp).to(beNil())
            }
        }
    }

}
