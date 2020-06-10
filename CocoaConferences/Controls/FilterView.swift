//
// Created by jetbrains on 07.02.2020.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import SwiftUI
import CCLibrary
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

class FilterViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            FilterView(filter: Filter(), reload: { (Filter) in }) {}.previewLayout(.sizeThatFits)
        }
    }

    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
                UIHostingController(rootView: FilterViewPreview.previews)
    }
    #endif
}
