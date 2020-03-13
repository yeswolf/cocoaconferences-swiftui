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
        try decode(type, from: String(data: data.data, encoding: .utf8)!)
    }

}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = YAMLDecoder()
        return try decoder.decode(T.self, from: String(data: data, encoding: .utf8)!)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


class API {

    private var url: String

    init(url: String) {
        self.url = url
    }

    func conferences(filter: Filter, completion: @escaping ([Conference]) -> Void) {
        _ = URLSession.shared.dataTaskPublisher(for: URL(string: confURL)!)
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
                                                       conferences.sorted {
                                                           if filter.asc { return $0.start! < $1.start! } else { return $0.start! > $1.start! }
                                                       }.filter { $0.start! > filter.start && $0.start! < filter.end }.filter {
                                                           !filter.cfpOpened || ($0.cfp != nil) && (($0.cfp!.deadline == nil) || ($0.cfp!.deadline != nil && $0.cfp!.deadline! > Date()))
                                                       }
                                               )
                                           })
    }
}

class Filter: ObservableObject {
    @Published var start: Date = Date()
    @Published var end: Date = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    @Published var cfpOpened: Bool = false
    @Published var asc: Bool = false
}

class ConferenceObserver: ObservableObject {
    @Published var conferences = [Conference]()

    init() {
        api.conferences(filter: Filter()) { conferences in
            self.conferences = conferences
        }
    }
}
