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
    
    @Environment(\.presentationMode) var presentationMode
    
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
        NavigationView {
        Form {
            Section {
                TextField("Item name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            } header: {
                Text("Basic settings")
            }  //: section 1
            
            Section {
                Picker("priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            } header: {
                Text("Priority")
            }  //: Priority picker section
            
            Section {
                Toggle("Mark Completed", isOn: $completed.onChange(update))
            }
        }  //: form
        .navigationTitle("Edit item")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Dismiss") {
                                presentationMode.wrappedValue.dismiss()
                            } //: Button
                        } //: ToolbarItem
                    } //: Toolbar
        }
        
        .onDisappear(perform: dataController.save)
//        ToolbarItem(placement: .navigationBarTrailing, content: {
//            Button("Dismiss") {
//                self.showModal.toggle()
//            }
//        })
            
    }  //: body
    
    func update() {
        item.project?.objectWillChange.send()
        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
    }
    
    func save(_ note: Notification) {
        dataController.save()
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
    }
}
