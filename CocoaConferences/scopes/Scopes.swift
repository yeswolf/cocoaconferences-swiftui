//
// Created by jetbrains on 11/16/20.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import Swinject

class Scopes {
    static let app: Container = {
        let container = common
        container.register(ConferencesSourceProtocol.self) { _ in
            ConferencesSource()
        }
        return container
    }()

    static let test: Container = {
        let container = common
        container.register(ConferencesSourceProtocol.self) { _ in
            PreviewConferencesSource()
        }
        return container
    }()

    static let common: Container = {
        let container = Container()
        container.register(ConferencesRepositoryProtocol.self) { r in
            ConferencesRepository(conferencesSource: r.resolve(ConferencesSourceProtocol.self)!)
        }
        container.register(GetFilteredConferencesUseCase.self) { r in
            GetFilteredConferencesUseCase(conferencesRepository: r.resolve(ConferencesRepositoryProtocol.self)!)
        }
        return container
    }()
}
