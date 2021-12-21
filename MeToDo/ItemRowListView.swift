//
//  ItemRowListView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/15.
//

import SwiftUI

struct ItemRowListView: View {
    // MARK: - Properties
    @ObservedObject var project: Project
    @ObservedObject var item: Item
    @State private var showModal = false
    // MARK: - Body
    var body: some View {
        //        NavigationLink(destination: EmptyView()) {
        Button {
            showModal.toggle()
        } label: {
            Label {
                Text(item.itemTitle)
            } icon: {
                priorityIcon()
            }
        }
        .sheet(isPresented: $showModal) {
            EditItemView(item: item)
        }
        .onTapGesture {
            showModal.toggle()
        }
        //        }  //: item NavLink
    }

    func priorityIcon() -> some View {
        if item.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(project.projectColor))
        } else if item.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(project.projectColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
}

struct ItemRowListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowListView(project: Project.example, item: Item.example)
    }
}
