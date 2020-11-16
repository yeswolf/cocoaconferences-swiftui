//
// Created by jetbrains on 11/13/20.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import Combine

protocol ConferencesSourceProtocol {
    func getConferences() -> URLSession.DataTaskPublisher
}

class ConferencesSource: ConferencesSourceProtocol {
    private let confURL = "https://raw.githubusercontent.com/Lascorbe/CocoaConferences/master/_data/conferences.yml"

    func getConferences() -> URLSession.DataTaskPublisher {
        URLSession.shared.dataTaskPublisher(for: URL(string: confURL)!)
    }
}

class PreviewConferencesSource: ConferencesSourceProtocol {
    func getConferences() -> URLSession.DataTaskPublisher {
        URLSession.shared.dataTaskPublisher(for: Bundle.main.url(forResource: "conferences", withExtension: "yaml")!)
    }
}