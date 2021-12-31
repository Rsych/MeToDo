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
    @EnvironmentObject var dataController: DataController
    // MARK: - Body
    var body: some View {
        HStack(spacing: 20) {
            priorityIcon()
                .onTapGesture {
                    item.completed.toggle()
                    dataController.save()
                }
            Button {
                showModal.toggle()
            } label: {
                Text(item.itemTitle)
            }
            .sheet(isPresented: $showModal) {
                EditItemView(item: item)
            }
            .onTapGesture {
                showModal.toggle()
            }
        }
//        Button {
//            showModal.toggle()
//        } label: {
//            Label {
//                Text(item.itemTitle)
//            } icon: {
//                priorityIcon()
//            }
//        }
    }

//    func priorityIcon() -> some View {
//        if item.completed {
//            return Image(systemName: "checkmark.circle")
//                .foregroundColor(Color(project.projectColor))
//        } else if item.priority == 3 {
//            return Image(systemName: "exclamationmark.triangle")
//                .foregroundColor(Color(project.projectColor))
//        } else {
//            return Image(systemName: "checkmark.circle")
//                .foregroundColor(.clear)
//        }
//    }
    func priorityIcon() -> some View {
        if item.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(project.projectColor))
        } else {
            return Image(systemName: "circle")
                .foregroundColor(Color(project.projectColor))
        }
    }
}

struct ItemRowListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowListView(project: Project.example, item: Item.example)
    }
}
