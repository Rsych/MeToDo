//
//  ItemRowListView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/15.
//

import SwiftUI

struct ItemRowListView: View {
     // MARK: - Properties
    @ObservedObject var item: Item
    @State private var showModal = false
    // MARK: - Body
    var body: some View {
//        NavigationLink(destination: EditItemView(item: item)) {
            Text(item.itemTitle)
            .sheet(isPresented: $showModal) {
                EditItemView(item: item)
            }
            .onTapGesture {
                showModal.toggle()
            }

//        }  //: item NavLink
    }
}

struct ItemRowListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowListView(item: Item.example)
    }
}
