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

    init() {
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

    func textDates() -> String {
        var result = "🗓 \(start!.friendly())"
        if let end = self.end {
            result = "\(result) - \(end.friendly())"
        }
        return result
    }
}
