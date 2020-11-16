//
// Created by jetbrains on 11/16/20.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import Combine
import Yams

protocol ConferencesRepositoryProtocol {
    func getConferences() -> AnyPublisher<[Conference], Error>
}

class ConferencesRepository : ConferencesRepositoryProtocol {
    private let conferencesSource: ConferencesSourceProtocol

    init(conferencesSource: ConferencesSourceProtocol) {
        self.conferencesSource = conferencesSource
    }

    func getConferences() -> AnyPublisher<[Conference], Error> {
        conferencesSource.getConferences()
                .decode(type: [Conference].self, decoder: ConferencesMapper())
                .eraseToAnyPublisher()
    }
}
