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
import Swinject
import Combine
@testable import CocoaConferences

class ConferencesSpec: QuickSpec {

    private var getFilteredConferences: GetFilteredConferencesUseCase {
        get {
            Scopes.test.resolve(GetFilteredConferencesUseCase.self)!
        }
    }
    private var disposables = Set<AnyCancellable>()

    override func spec() {
        super.spec()
        describe("Source") {
            it("should load conference list from YAML") {
                waitUntil { [self] done in
                    getFilteredConferences.execute(filter: Filter())
                            .receive(on: RunLoop.main)
                            .sink(receiveCompletion: { completion in }, receiveValue: { conferences in
                                expect(conferences).toNot(beEmpty())
                                expect(conferences.count).to(beGreaterThan(1))
                                expect(conferences[0].name).toNot(beEmpty())
                                done()
                            })
                            .store(in: &disposables)
                }
            }
        }
    }
}
