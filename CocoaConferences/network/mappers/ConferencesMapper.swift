//
// Created by jetbrains on 11/16/20.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import Yams
import Combine
import SwiftUI

typealias ConferencesMapper = YAMLDecoder

extension YAMLDecoder: TopLevelDecoder {
    public typealias Input = URLSession.DataTaskPublisher.Output

    public func decode<T: Decodable>(_ type: T.Type, from data: Input) throws -> T {
        try decode(type, from: String(data: data.data, encoding: .utf8)!)
    }
}