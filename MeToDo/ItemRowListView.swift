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
    
    
    // MARK: - Body
    var body: some View {
//        NavigationLink(destination: EditItemView(item: item)) {
            Text(item.itemTitle)
                
//        }  //: item NavLink
    }
}

struct ItemRowListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowListView(item: Item.example)
    }
}
