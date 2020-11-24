//
// Created by jetbrains on 07.02.2020.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import SwiftUI

class ConferenceDetailViewModel: ObservableObject {
    var conference: Conference

    init(conference: Conference) {
        self.conference = conference
    }

    var link: LinkButtonViewModel {
        get {
            LinkButtonViewModel(title: conference.link!, link: conference.link!)
        }
    }
    var dates: String {
        get {
            var result = "🗓 \(conference.start!.friendly())"
            if let end = conference.end {
                result = "\(result) - \(end.friendly())"
            }
            return result
        }
    }
    var location: String {
        get {
            conference.location
        }
    }
    var hasCfp: Bool {
        get {
            conference.cfp != nil
        }
    }
    var deadline: LinkButtonViewModel {
        get {
            var title = "Deadline not specified"
            let link = conference.cfp!.link
            if conference.cfp!.deadline != nil {
                title = conference.cfp!.deadline!.friendly()
            }
            return LinkButtonViewModel(title: title, link: link)
        }
    }

    var title: String {
        get {
            conference.name
        }
    }
}

struct ConferenceDetail: View {
    @ObservedObject var viewModel: ConferenceDetailViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack {
                Text("🔗")
                LinkButton(viewModel: viewModel.link)
            }
            Text(viewModel.dates)
            Text(viewModel.location)
            HStack {
                Text("🖊")
                if viewModel.hasCfp {
                    LinkButton(viewModel: viewModel.deadline)
                } else {
                    Text("See website for details")
                }
            }
        }.navigationBarTitle(viewModel.title)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding([.leading, .trailing], 20)
    }
}

class ConferenceDetailPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ConferenceDetail(viewModel: ConferenceDetailViewModel(conference:Conference()))
        }
    }

    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
                UIHostingController(rootView: ConferenceDetailPreview.previews)
    }
    #endif
}
