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
    @EnvironmentObject var dataController: DataController
    
    @State private var showSpotModal = false
    
    var projectRows: [GridItem] {
        [GridItem(.adaptive(minimum: 0, maximum: 100))]
    }
    //    var projectRows: [GridItem] {
    //        [GridItem(.fixed(100))]
    //    }
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
        
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                WeekCalendarView(calendar: Calendar(identifier: .gregorian), dataController: dataController)
                    .frame(maxHeight: UIScreen.main.bounds.height / 6)
                ScrollView {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            HomeItemListView(title: "Up next", items: $viewModel.upNext)
                            HomeItemListView(title: "More to explore", items: $viewModel.moreToExplore)
                        } //: VStack
                        .padding(.bottom, 50)
                        .padding(.horizontal)
                    } //: VStack
                }  //: ScrollView
                .background(Color(uiColor: .systemBackground))
                .navigationBarHidden(true)
                .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
                .fullScreenCover(isPresented: $showSpotModal) {
                    EditItemView(item: viewModel.selectedItem ?? Item.example)
                }
            } //: VStack
        }  //: NavView
        .navigationBarHidden(true)
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
            .environmentObject(DataController())
            .preferredColorScheme(.dark)
    }
}
