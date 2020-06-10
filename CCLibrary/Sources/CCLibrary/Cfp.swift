import Foundation

public class Cfp: Codable {

    public var link: String //https://goo.gl/forms/eoX2WfG1LRoZPxxo1
    public var deadline: Date? //2019-02-28

    public init() {
        link = ""
        deadline = nil
    }
}
