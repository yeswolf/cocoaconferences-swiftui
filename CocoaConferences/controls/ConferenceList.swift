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

#warning("FIXME: nobody knows why doesn't it work as @State")
private var disposables = Set<AnyCancellable>()

struct ConferenceList: View {
    @ObservedObject var filter: Filter = Filter()

    @State var conferences = [Conference]()

    @State var filterOpened = false

    private var getFilteredConferences: GetFilteredConferencesUseCase {
        get {
            Scopes.app.resolve(GetFilteredConferencesUseCase.self)!
        }
    }

    var body: some View {
        NavigationView {
            List(conferences) { conference in
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
                                FilterView(filter: self.filter, reload: { [self] filter in
                                    self.filterOpened.toggle()
                                    getFilteredConferences.execute(filter: self.filter)
                                            .receive(on: RunLoop.main)
                                            .sink(receiveCompletion: { completion in }, receiveValue: { [self] conferences in
                                                self.conferences = conferences
                                            })
                                            .store(in: &disposables)
                                }, dismiss: {
                                    self.filterOpened.toggle()
                                })
                            })
                    )
        }.onAppear {
            getFilteredConferences.execute(filter: Filter())
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { completion in }, receiveValue: { [self] conferences in
                        self.conferences = conferences
                    })
                    .store(in: &disposables)
        }
    }
}

class ConferenceListPreviews: PreviewProvider {
    static var previews: some View {
        let conferencesRepository = ConferencesRepository(conferencesSource: PreviewConferencesSource())
        let getConferences = GetFilteredConferencesUseCase(conferencesRepository: conferencesRepository)
        var mockConferences: [Conference] = [Conference()]
        getConferences.execute(filter: Filter())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in }, receiveValue: { conferences in
                    mockConferences = conferences
                    print(conferences)
                }).store(in: &disposables)
        return ConferenceList(filter: Filter(), conferences: mockConferences, filterOpened: false).previewDevice("iPhone 11")
    }

    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
                UIHostingController(rootView: ConferenceListPreviews.previews)
    }
    #endif
}
