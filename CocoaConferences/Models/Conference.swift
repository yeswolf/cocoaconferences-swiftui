import Foundation
import Yams

class Conference: Codable, Identifiable {
    var name = ""
    var location: String
    var cocoaOnly = false
    var start: Date?
    var end: Date?
    var cfp: Cfp?
    var link: String?

    private enum CodingKeys: String, CodingKey {
        case cfp
        case cocoaOnly = "cocoa-only"
        case end
        case link
        case location
        case name
        case start
    }

    func textDates() -> String {
        var result = "🗓 \(start!.friendly())"
        if let end = self.end {
            result = "\(result) - \(end.friendly())"
        }
        return result
    }
}
