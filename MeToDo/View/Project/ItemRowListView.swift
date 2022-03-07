//
//  ItemRowListView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/15.
//

import SwiftUI
import PartialSheet

struct ItemRowListView: View {
    // MARK: - Properties
    @ObservedObject var project: Project
    @ObservedObject var item: Item
    @State private var showModal = false
    @EnvironmentObject var dataController: DataController
    @Environment(\.colorScheme) var colorScheme
    
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
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
//            .sheet(isPresented: $showModal) {
//                EditItemView(item: item)
//            }
            .partialSheet(isPresented: $showModal, type: .dynamic, content: {
                EditItemView(item: item)
                    .environment(\.showingSheet, self.$showModal)
            })
            .onTapGesture {
                showModal.toggle()
            }
        }  //: HStack
            Rectangle().fill(Color.secondary).frame(maxWidth: .infinity, maxHeight: 1, alignment: .leading)
        }  //: Vstack
    }

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
