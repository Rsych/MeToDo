//
//  HomeItemListView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/23.
//

import SwiftUI

struct HomeItemListView: View {
    @State private var selectedItem: FetchedResults<Item>.Element?
    let title: LocalizedStringKey
    let items: ArraySlice<Item>
    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)

            ForEach(items) { item in
                    HStack(spacing: 20) {
                        Button {
                            self.selectedItem = item
                        } label: {
                            Circle()
                                .stroke(Color(item.project?.projectColor ?? "Orange"), lineWidth: 3)
                                .frame(width: 44, height: 44)

                            homeList(item)
                        }  //: ButtonView
                    }  //: HStack
                    .padding()
                    .background(.thickMaterial)
                    .cornerRadius(10)
                    .shadow(color: .primary.opacity(0.2), radius: 2)
                    .sheet(item: $selectedItem) {
                        EditItemView(item: $0)
                    }
            }
        }
    }  //: body
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

// struct HomeItemListView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeItemListView(title: "", items: <#T##FetchedResults<Item>.SubSequence#>)
//    }
// }
