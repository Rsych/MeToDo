//
//  HomeView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/13.
//

import SwiftUI
import CoreSpotlight
import CoreData
import CloudKit

struct HomeView: View {
    // MARK: - Properties
    static let homeTag: Int = 0

    @StateObject var viewModel: ViewModel

    @State private var showSpotModal = false

    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)

    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(viewModel.projects) { project in
                                ProjectSummaryView(project: project)
                            }  //: project Loop
                        }  //: LazyHGrid
                        .padding([.top, .horizontal])
                        .fixedSize(horizontal: false, vertical: true)
                    }  //: ScrollView
                    VStack(alignment: .leading) {
                        HomeItemListView(title: "Up next", items: $viewModel.upNext)
                        HomeItemListView(title: "More to explore", items: $viewModel.moreToExplore)
                    }  //: VStack
                    .padding(.bottom, 50)
                    .padding(.horizontal)
                }  //: VStack
            }  //: ScrollView
            .background(Color.systemGroupedBackground)
            .navigationTitle("Home")
//            .navigationBarTitleDisplayMode(.inline)
            #if targetEnvironment(simulator)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Add Data Debug") {
                        viewModel.addSampleData()
                    }
                }
            }  //: toolbar
            #endif

            .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
            .sheet(isPresented: $showSpotModal) {
                EditItemView(item: viewModel.selectedItem ?? Item.example)
            }
        }  //: NavView
    }  //: body
    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as?
            String {
            viewModel.selectedItem(with: uniqueIdentifier)
            showSpotModal.toggle()
        }

    }
}  //: view

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
    }
}
