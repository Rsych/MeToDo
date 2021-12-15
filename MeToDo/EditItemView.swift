//
//  EditItemView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/15.
//

import SwiftUI

struct EditItemView: View {
    // MARK: - Properties
    let item: Item
    
    @EnvironmentObject var dataController: DataController
    
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool
    
    init(item: Item) {
        self.item = item
        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
    }
    
    // MARK: - Body
    var body: some View {
        Form {
            Section {
                TextField("Item name", text: $title)
                TextField("Description", text: $detail)
            } header: {
                Text("Basic settings")
            }  //: section 1
            
            Section {
                Picker("priority", selection: $priority) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            } header: {
                Text("Priority")
            }  //: Priority picker section
            
            Section {
                Toggle("Mark Completed", isOn: $completed)
            }
        }  //: form
        .navigationTitle("Edit Item")
        .onDisappear {
            update()
        }
    }  //: body
    
    func update() {
        item.project?.objectWillChange.send()
        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
    }
}
