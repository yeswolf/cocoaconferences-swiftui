//
//  ContentView.swift
//  CocoaConferences
//
//  Created by jetbrains on 15.11.2019.
//  Copyright © 2019 JetBrains. All rights reserved.
//

import SwiftUI
import Combine
import Swinject

class ConferenceListViewModel: ObservableObject {
    @Published var conferences = [Conference]()
    @Published var filterOpened = false
    var filter = Filter()
    private var disposables = Set<AnyCancellable>()

    private var getFilteredConferences: GetFilteredConferencesUseCase {
        get {
            Scopes.app.resolve(GetFilteredConferencesUseCase.self)!
        }
    }

    func reload(filter: Filter){
        self.filter = filter
        getFilteredConferences.execute(filter: filter)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in }, receiveValue: { [self] conferences in
                    self.conferences = conferences
                    closeFilter()
                })
                .store(in: &disposables)
    }

    func closeFilter(){
        filterOpened = false
    }

    func toggleFilter() {
        filterOpened.toggle()
    }
}

struct ConferenceList: View {
    @ObservedObject var viewModel: ConferenceListViewModel = ConferenceListViewModel()
    var body: some View {
        NavigationView {
            List(viewModel.conferences) { conference in
                NavigationLink(destination: ConferenceDetail(viewModel: ConferenceDetailViewModel(conference: conference))) {
                    VStack(alignment: .leading) {
                        Text(conference.name).font(.headline)
                        Text(conference.location).font(.subheadline)
                    }
                }
            }.navigationBarTitle("Conferences")
                    .navigationBarItems(
                            trailing: Button(action: {
                                viewModel.toggleFilter()
                            }, label: {
                                Text("Filter")
                            }).popover(isPresented: $viewModel.filterOpened, content: {
                                FilterView(viewModel: FilterViewModel(start: viewModel.filter.start,
                                        end: viewModel.filter.end, cfpOpened: viewModel.filter.cfpOpened, asc: viewModel.filter.asc, reload: { filter in
                                    viewModel.reload(filter: filter)
                                }, dismiss: {
                                    viewModel.toggleFilter()
                                }
                                ))
                            })
                    )
        }.onAppear {
            viewModel.reload(filter: Filter())
        }
    }
}

class ConferenceListPreviews: PreviewProvider {
    static var previews: some View {
        let viewModel: ConferenceListViewModel = ConferenceListViewModel() 
        viewModel.conferences = [Conference()]
        return ConferenceList(viewModel: viewModel).previewDevice("iPhone 11")
    }

    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
                UIHostingController(rootView: ConferenceListPreviews.previews)
    }
    #endif
}
