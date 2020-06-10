import Foundation
import Yams
import Combine

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
        var comps =
                Calendar.current.dateComponents([.year, .month, .day], from: result)
        comps.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar.current.date(from: comps)!
    }
}

extension YAMLDecoder: TopLevelDecoder {
    @available(iOS 13.0, *)
    public typealias Input = URLSession.DataTaskPublisher.Output

    @available(iOS 13.0, *)
    public func decode<T: Decodable>(_ type: T.Type, from data: Input) throws -> T {
        try decode(type, from: String(data: data.data, encoding: .utf8)!)
    }
}

public func load<T: Decodable>(_ filename: String) -> T {
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
