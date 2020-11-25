//
// Created by jetbrains on 07.02.2020.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class FilterViewModel: ObservableObject {
    @Published var filter: Filter
    var reload: (Filter) -> Void
    var dismiss: () -> Void

    init(filter: Filter, reload: @escaping (Filter) -> (), dismiss: @escaping () -> ()) {
        self.reload = reload
        self.dismiss = dismiss
        self.filter = filter
    }

    func filterChanged(){
        reload(filter)
    }
}

public struct FilterView: View {
    @ObservedObject var viewModel: FilterViewModel
    public var body: some View {
        NavigationView {
            HStack {
                VStack(alignment: .leading) {
                    List {
                        Section(header: Text("START DATE")) {
                            DatePicker("", selection: self.$viewModel.filter.start, displayedComponents: .date).labelsHidden()
                        }
                        Section(header: Text("END DATE")) {
                            DatePicker("", selection: self.$viewModel.filter.end, displayedComponents: .date).labelsHidden()
                        }
                        Section(header: Text("OPTIONS")) {
                            Checkbox(text: "CFP opened", checked: self.$viewModel.filter.cfpOpened)
                            Checkbox(text: "Sort ASC", checked: self.$viewModel.filter.asc)
                        }
                    }.listStyle(GroupedListStyle())
                }.navigationBarItems(
                        leading: Button(action: {
                            viewModel.dismiss()
                        }, label: { Text("Cancel") }),
                        trailing: Button(action: {
                            viewModel.filterChanged()
                        }, label: { Text("Filter") })
                ).navigationBarTitle("Filter", displayMode: .automatic)
            }
        }.frame(minHeight: 600).frame(minWidth: 400)
    }
}

class FilterViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            let filter = Filter()
            FilterView(viewModel: FilterViewModel(filter: filter, reload: { filter in }, dismiss: {})).previewDevice("iPhone 11")
        }
    }

    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
                UIHostingController(rootView: FilterViewPreview.previews)
    }
    #endif
}
