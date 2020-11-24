//
// Created by jetbrains on 07.02.2020.
// Copyright (c) 2020 JetBrains. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class FilterViewModel: ObservableObject {
    private var disposables = Set<AnyCancellable>()

    private var getFilteredConferences: GetFilteredConferencesUseCase {
        get {
            Scopes.app.resolve(GetFilteredConferencesUseCase.self)!
        }
    }

    @Published var start: Date
    @Published var end: Date
    @Published var cfpOpened: Bool
    @Published var asc: Bool
    var reload: (Filter) -> Void
    var dismiss: () -> Void

    init(start: Date, end: Date, cfpOpened: Bool, asc: Bool, reload: @escaping (Filter) -> (), dismiss: @escaping () -> ()) {
        self.start = start
        self.end = end
        self.cfpOpened = cfpOpened
        self.asc = asc
        self.reload = reload
        self.dismiss = dismiss
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
                            DatePicker("", selection: self.$viewModel.start, displayedComponents: .date).labelsHidden()
                        }
                        Section(header: Text("END DATE")) {
                            DatePicker("", selection: self.$viewModel.end, displayedComponents: .date).labelsHidden()
                        }
                        Section(header: Text("OPTIONS")) {
                            Checkbox(text: "CFP opened", checked: self.$viewModel.cfpOpened)
                            Checkbox(text: "Sort ASC", checked: self.$viewModel.asc)
                        }
                    }.listStyle(GroupedListStyle())
                }.navigationBarItems(
                        leading: Button(action: {
                            viewModel.dismiss()
                        }, label: { Text("Cancel") }),
                        trailing: Button(action: {
                            viewModel.reload(Filter(start: viewModel.start,
                                    end: viewModel.end, cfpOpened: viewModel.cfpOpened, asc: viewModel.asc))
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
            FilterView(viewModel: FilterViewModel(start: filter.start, end: filter.end, cfpOpened: filter.cfpOpened, asc: filter.asc, reload: { filter in }, dismiss: {})).previewLayout(.sizeThatFits)
        }
    }

    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
                UIHostingController(rootView: FilterViewPreview.previews)
    }
    #endif
}
