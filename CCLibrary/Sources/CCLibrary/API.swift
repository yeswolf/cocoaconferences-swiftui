import Foundation
import Combine
import Yams

@available(iOS 13.0, *)
public let CCAPI = API(url: "https://raw.githubusercontent.com/Lascorbe/CocoaConferences/master/_data/conferences.yml")

@available(iOS 13.0, *)
public class API {

    private var url: String

    private var result: AnyCancellable?

    public init(url: String) {
        self.url = url
    }

    public func conferences(filter: Filter, completion: @escaping ([Conference]) -> Void) {
        result = URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
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
                                                             if filter.asc {
                                                                 return $0.start < $1.start
                                                             } else {
                                                                 return $0.start > $1.start
                                                             }
                                                         }
                                                         .filter {
                                                             if let end = $0.end {
                                                                 return $0.start > filter.start && end < filter.end
                                                             } else {
                                                                 return $0.start > filter.start && $0.start < filter.end
                                                             }
                                                         }
                                                         .filter {
                                                               var result = !filter.cfpOpened
                                                               if let cfp = $0.cfp, let deadline = cfp.deadline {
                                                                   result = result || deadline > Date()
                                                               }
                                                               return result
                                                         }
                                      )
                                  })
    }
}
