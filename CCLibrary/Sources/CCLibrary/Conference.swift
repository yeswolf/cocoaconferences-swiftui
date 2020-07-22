import Foundation
public class Conference: Codable, Identifiable {
    public var name = ""
    public var location: String
    public var cocoaOnly = false
    public var start: Date
    public var end: Date?
    public var cfp: Cfp?
    public var link: String?

    public init() {
        name = "%name%"
        location = "%location%"
        cocoaOnly = false
        start = Date()
        end = Date()
        cfp = Cfp()
        cfp?.deadline = Date()
        cfp?.link = "https://www.google.com"
        link = "https://www.google.com"
    }

    private enum CodingKeys: String, CodingKey {
        case cfp
        case cocoaOnly = "cocoa-only"
        case end
        case link
        case location
        case name
        case start
    }

    public func textDates() -> String {
        var result = "\(start.friendly())"
        if let end = self.end {
            if start < end {
                result = "\(result) - \(end.friendly())"
            } else if start > end {
                result = "\(end.friendly()) - \(result)"
            }
        }
        return "🗓 \(result)"
    }
}
