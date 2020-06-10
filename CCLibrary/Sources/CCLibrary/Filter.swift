import Foundation

public class Filter: ObservableObject {
    @Published public var start: Date = Date()
    @Published public var end: Date = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    @Published public var cfpOpened: Bool = false
    @Published public var asc: Bool = false

    public init() {

    }
}
