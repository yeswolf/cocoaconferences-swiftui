//
//  ContentView.swift
//  CocoaConferences
//
//  Created by jetbrains on 15.11.2019.
//  Copyright © 2019 JetBrains. All rights reserved.
//

import SwiftUI
import CCLibrary
struct ConferenceList: View {
    @ObservedObject var data = ConferenceObserver()
    @State var filterOpened = false
    var filter: Filter = Filter()
    var body: some View {
        NavigationView {
            List(data.conferences) { conference in
                NavigationLink(destination: ConferenceDetail(conference: conference)) {
                    VStack(alignment: .leading) {
                        Text(conference.name).font(.headline)
                        Text(conference.location).font(.subheadline)
                    }
                }
            }.navigationBarTitle("Conferences")
             .navigationBarItems(
                     trailing: Button(action: {
                         self.filterOpened.toggle()
                     }, label: {
                         Text("Filter")
                     }).popover(isPresented: $filterOpened, content: {
                         FilterView(filter: self.filter, reload: { filter in
                             self.filterOpened.toggle()
                             CCAPI.conferences(filter: self.filter) { conferences in
                                 self.data.conferences = conferences
                             }
                         }, dismiss: {
                             self.filterOpened.toggle()
                         })
                     })
             )
        }
    }
}

class ConferenceListPreviews: PreviewProvider {
    static var previews: some View {
        let observer = ConferenceObserver()
        observer.conferences = load("conferences.yaml")
        return ConferenceList(data: observer, filterOpened: false, filter: Filter())
    }

    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
                UIHostingController(rootView: ConferenceListPreviews.previews)
    }
    #endif
}