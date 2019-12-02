//
// Created by jetbrains on 15.11.2019.
// Copyright (c) 2019 JetBrains. All rights reserved.
//

import Foundation
import Yams
import Combine
import SwiftUI

let confURL = "https://raw.githubusercontent.com/Lascorbe/CocoaConferences/master/_data/conferences.yml"

extension Date {
    public func friendly() -> String {
        let format = DateFormatter()
        format.dateFormat = "MMMM dd, yyyy"
        format.locale = Locale(identifier: "en_US_POSIX")
        return format.string(from: self)
    }
}

extension String {
    public func date() -> Date {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.locale = Locale(identifier: "en_US_POSIX")
        let result = format.date(from: self)!
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: result)
        comps.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar.current.date(from: comps)!
    }
}

extension YAMLDecoder: TopLevelDecoder {
    public typealias Input = URLSession.DataTaskPublisher.Output

    public func decode<T: Decodable>(_ type: T.Type, from data: Input) throws -> T {
        return try decode(type, from: String(data: data.data, encoding: .utf8)!)
    }
}

class API {

    private var url: String

    init(url: String) {
        self.url = url
    }

    func conferences(filter: Filter, completion: @escaping (([Conference]) -> Void)) {
        URLSession.shared.dataTaskPublisher(for: URL(string: confURL)!)
                .decode(type: [Conference].self, decoder: YAMLDecoder())
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }, receiveValue: { conferences in
                    completion(
                            conferences.sorted { $0.start! > $1.start! }.filter { (($0.cfp != nil) && ($0.cfp!.deadline == nil || $0.cfp!.deadline! > Date())) == filter.cfpOpened }.filter { $0.start! > filter.start && $0.start! < filter.end }
                    )
                })
    }
}

class Filter: ObservableObject {
    @Published var start: Date = Date()
    @Published var end: Date = Calendar.current.date(byAdding: .year, value: 1, to:Date())!
    @Published var cfpOpened: Bool = false
}

class ConferenceObserver: ObservableObject {
    @Published var conferences = [Conference]()

    init() {
        api.conferences(filter: Filter()) { conferences in
            self.conferences = conferences
        }
    }
}