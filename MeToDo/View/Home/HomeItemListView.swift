//
//  HomeItemListView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/23.
//

import SwiftUI

struct HomeItemListView: View {
    // MARK: - Properties
    @State private var selectedItem: FetchedResults<Item>.Element?
    @EnvironmentObject var dataController: DataController
    let title: LocalizedStringKey
    @Binding var items: ArraySlice<Item>
    
    @State private var showModal = false
    @State private var modalSelectedItem: Item? = nil
    // MARK: - Body
    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            ForEach(items) { item in
                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(Color(item.project?.projectColor ?? "Orange"), lineWidth: 3)
                            .frame(width: 44, height: 44)
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 44, height: 44)
                    }
                    .onTapGesture {
                        withAnimation {
                            item.completed.toggle()
                            dataController.save()
                        }
                    }
                    Button {
                        itemSelected(item: item)
                        self.selectedItem = item
                    } label: {
                        homeList(item)
                    }  //: ButtonView
                }  //: HStack
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(10)
                .shadow(color: .primary.opacity(0.2), radius: 2)
                //                    .sheet(item: $selectedItem) {
                //                        EditItemView(item: $0)
                //                    }
                .partialSheet(isPresented: $showModal) {
                    if modalSelectedItem != nil {
                        EditItemView(item: modalSelectedItem!)
                            .environment(\.showingSheet, $showModal)
                    }
                }
            }
        }
    }  //: body
    func itemSelected(item: Item) {
        self.showModal = true
        self.modalSelectedItem = item
    }
    func homeList(_ item: Item) -> some View {
        VStack(alignment: .leading) {
            Text(item.itemTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .foregroundColor(Color(item.project?.projectColor ?? "Orange"))
            Text(item.project!.projectTitle)
                .font(.caption)
                .foregroundColor(Color(item.project?.projectColor ?? "Orange"))
            if item.itemDetail.isEmpty == false {
                Text(item.itemDetail)
                    .foregroundColor(.secondary)
            }
        }  //: VStack
    }  //: homeListView
}
