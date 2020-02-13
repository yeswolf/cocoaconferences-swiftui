//
// Created by jetbrains on 07.02.2020.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import SwiftUI

struct ConferenceDetail: View {
    var conference: Conference
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack {
                Text("🔗" )
                LinkButton(title: self.conference.link!, link: self.conference.link!)
            }
            Text(conference.textDates())
            Text(conference.location)
            HStack {
                Text("🖊")
                if conference.cfp == nil {
                    Text("See website for details")
                } else {
                    if conference.cfp!.deadline != nil {
                        LinkButton(title:self.conference.cfp!.deadline!.friendly(), link: self.conference.cfp!.link)
                    } else {
                        LinkButton(title: "Deadline not specified", link: self.conference.cfp!.link)
                    }
                }
            }
        }.navigationBarTitle(conference.name)
         .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
         .padding([.leading, .trailing], 20)
    }
}


class ConferenceDetailPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ConferenceDetail(conference: Conference())
        }
    }
    #if DEBUG
    @objc class func injected() {
           UIApplication.shared.windows.first?.rootViewController =
           UIHostingController(rootView: ConferenceDetailPreview.previews)
    }
    #endif
}
