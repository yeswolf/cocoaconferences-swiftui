//
// Created by jetbrains on 11/16/20.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import Combine

extension Publisher where Output: Sequence {
    typealias Sorter = (Output.Element, Output.Element) -> Bool

    func sort(
            by sorter: @escaping Sorter
    ) -> Publishers.Map<Self, [Output.Element]> {
        map { sequence in
            sequence.sorted(by: sorter)
        }
    }

    func filter(isIncluded: @escaping (Output.Element) -> Bool) -> Publishers.Map<Self, [Output.Element]> {
        map { sequence in
            sequence.filter(isIncluded)
        }
    }
}

class GetFilteredConferencesUseCase {
    private let conferencesRepository: ConferencesRepositoryProtocol

    init(conferencesRepository: ConferencesRepositoryProtocol) {
        self.conferencesRepository = conferencesRepository
    }

    func execute(filter: Filter) -> AnyPublisher<[Conference], Error> {
        conferencesRepository.getConferences().sort {
            if filter.asc {
                return $0.start! < $1.start!
            } else {
                return $0.start! > $1.start!
            }
        }.filter {
            $0.start! > filter.start && $0.start! < filter.end
        }.filter {
            !filter.cfpOpened || ($0.cfp != nil) && (($0.cfp!.deadline == nil) || ($0.cfp!.deadline != nil && $0.cfp!.deadline! > Date()))
        }.eraseToAnyPublisher()
    }
}
