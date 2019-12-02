//
//  ContentView.swift
//  CocoaConferences
//
//  Created by jetbrains on 15.11.2019.
//  Copyright © 2019 JetBrains. All rights reserved.
//

import SwiftUI

public struct Checkbox: View {
    var text = ""
    @Binding var checked: Bool

    public var body: some View {
        Button(action: {
            self.checked.toggle()
        }) {
            HStack {
                Image(systemName: self.checked ? "checkmark.square" : "square")
                Text(text)
            }
        }
    }
}9

extension Button where Label == Text {
    public init(link: String) {
        self.init(action: {
            let url = URL(string: link)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }) {
            return Text(link).underline()
        }
    }
}

public struct FilterView: View {
    @ObservedObject var filter: Filter
    var reload: (Filter) -> Void
    var dismiss: () -> Void

    public var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Choose start date")
                DatePicker("", selection: self.$filter.start, displayedComponents: .date).labelsHidden()
                Text("Choose end date")
                DatePicker("", selection: self.$filter.end, displayedComponents: .date).labelsHidden()
                Checkbox(text: "CFP opened", checked: self.$filter.cfpOpened)
                Text(self.filter.start.friendly())
            }.navigationBarTitle("Filter")
                    .navigationBarItems(
                            leading: Button(action: {
                                self.reload(self.filter)
                            }, label: { Text("Filter") }),
                            trailing: Button(action: {
                                self.dismiss()
                            }, label: { Text("Close") })
                    )

        }

    }
}

//TODO: we can make it better
struct ConferenceDetail: View {
    var conference: Conference
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("🔗")
                Button(link: self.conference.link!)
            }
            Text(conference.textDates())
            Text(conference.location)
            if conference.cfp != nil {
                HStack {
                    Text("🖊🔗")
                    Button(link: self.conference.cfp!.link)
                }
                if (conference.cfp!.deadline != nil) {
                    Text("🖊🗓 \(conference.cfp!.deadline!.friendly())")
                } else {
                    Text("🖊🔗 not announced")
                }
            }
        }.navigationBarTitle(conference.name)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

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
                                self.filterOpened = true
                            }, label: {
                                Text("Filter")
                            }).popover(isPresented: $filterOpened, content: {
                                FilterView(filter: self.filter, reload: { filter in
                                    self.filterOpened = false
                                    api.conferences(filter: self.filter) { conferences in
                                        self.data.conferences = conferences
                                    }
                                }, dismiss: {
                                    self.filterOpened = false
                                })
                            })
                    )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConferenceList()
    }
}

class Refresher {
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
                UIHostingController(rootView: ConferenceList())
    }
}