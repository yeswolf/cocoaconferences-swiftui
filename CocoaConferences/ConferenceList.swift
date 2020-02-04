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
        HStack {
            Toggle(isOn: self.$checked) {
                Text(text)
            }
        }
    }
}

public struct LinkButton: View {
    var title = ""
    var link = ""
    public var body: some View {
        Button(action: {
            let url = URL(string: self.link)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }) {
            Text(self.title).underline().lineLimit(1)
        }
    }
}

public struct FilterView: View {
    @ObservedObject var filter: Filter
    var reload: (Filter) -> Void
    var dismiss: () -> Void

    public var body: some View {
        NavigationView {
            HStack {
                VStack(alignment: .leading) {
                    List {
                        Section(header: Text("START DATE")) {
                            DatePicker("", selection: self.$filter.start, displayedComponents: .date).labelsHidden()
                        }
                        Section(header: Text("END DATE")) {
                            DatePicker("", selection: self.$filter.end, displayedComponents: .date).labelsHidden()
                        }
                        Section(header: Text("OPTIONS")) {
                            Checkbox(text: "CFP opened", checked: self.$filter.cfpOpened)
                            Checkbox(text: "Sort ASC", checked: self.$filter.asc)
                        }

                    }.listStyle(GroupedListStyle())
                }.navigationBarItems(
                        leading: Button(action: {
                            self.dismiss()
                        }, label: { Text("Cancel") }),
                        trailing: Button(action: {
                            self.reload(self.filter)
                        }, label: { Text("Filter") })
                ).navigationBarTitle("Filter", displayMode: .automatic)
            }
        }
    }
}

//TODO: we can make it better
struct ConferenceDetail: View {
    var conference: Conference
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack {
                Text("🔗")
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
                                    api.conferences(filter: self.filter) { conferences in
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