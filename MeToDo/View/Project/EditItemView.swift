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
    //    let project: Project
    
    @EnvironmentObject var dataController: DataController
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool
    @State private var projectTitle: String
    @State private var projectColor: String
    
    @State private var textHeight: CGFloat = 0
    var textFieldHeight: CGFloat {
            let minHeight: CGFloat = 30
            let maxHeight: CGFloat = 70
            
            if textHeight < minHeight {
                return minHeight
            }
            
            if textHeight > maxHeight {
                return maxHeight
            }
            
            return textHeight
        }
    
    init(item: Item) {
        self.item = item
        //        self.project = project
        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
        _projectTitle = State(wrappedValue: item.project!.projectTitle)
        _projectColor = State(wrappedValue: item.project?.projectColor ?? "Orange")
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                Group {
                    Section {
                        TextField("Task name", text: $title.onChange(update)).modifier(ClearButton(text: $title))
                        
//                        TextField("Description", text: $detail.onChange(update)).modifier(ClearButton(text: $detail))
                        ZStack(alignment: .topLeading) {
                            if detail.isEmpty {
                                Text("Description")
                                    .foregroundColor(Color(uiColor: .placeholderText))
                                    .padding(4)
                            }
                            DynamicHeightTextField(text: $detail.onChange(update), height: $textHeight).modifier(ClearButton(text: $detail))
                        }
                        .frame(height: textFieldHeight)
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
                }
                .listRowBackground(Color(uiColor: .systemFill))
                .foregroundColor(Color.primary)
            }  //: form
            .background(Color(uiColor: .systemBackground))
            //                    .listRowBackground(Color.clear)
            
            .onAppear(perform: {
                UITableView.appearance().backgroundColor = UIColor.clear
                UITableViewCell.appearance().backgroundColor = UIColor.clear
            })
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(projectTitle)
                        .foregroundColor(Color(projectColor))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        presentationMode.wrappedValue.dismiss()
                    } //: Button
                } //: ToolbarItem
            } //: Toolbar
            .tint(.primary)
        }  //: NavView
        
        .onDisappear(perform: save)
    }  //: body
    
    func update() {
        item.project?.objectWillChange.send()
        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
    }
    
    func save() {
        dataController.update(item)
    }
}

//struct EditItemView_Previews: PreviewProvider {
//    static var dataController = DataController.preview
//    static var previews: some View {
//        EditItemView(item: Item.example)
//    }
//}

struct ClearButton: ViewModifier
{
    @Binding var text: String
    
    public func body(content: Content) -> some View
    {
        HStack(alignment: .lastTextBaseline)
        {
            content
            
            if !text.isEmpty
            {
                Button(action:
                        {
                    self.text = ""
                })
                {
                    Image(systemName: "delete.left")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 8)
            }
        }
    }
}
