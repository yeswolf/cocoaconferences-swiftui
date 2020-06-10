import Foundation
import Combine

@available(iOS 13.0, *)
public class ConferenceObserver: ObservableObject {
    @Published public var conferences = [Conference]()
    public init() {
        CCAPI.conferences(filter: Filter()) { conferences in
            self.conferences = conferences
        }
    }
}
