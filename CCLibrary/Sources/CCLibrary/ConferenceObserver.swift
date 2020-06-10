import Foundation
import Combine

public class ConferenceObserver: ObservableObject {
    @Published public var conferences = [Conference]()
    public init() {
        CCAPI.conferences(filter: Filter()) { conferences in
            self.conferences = conferences
        }
    }
}