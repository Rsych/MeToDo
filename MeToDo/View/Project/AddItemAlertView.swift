//
//  AddItemAlertView.swift
//  MeToDo
//
//  Created by Kim Jongwon on 2022/07/20.
//

import SwiftUI

struct AddItemAlertView: View {
    @Binding var showAddItem: Bool
    @Binding var itemTitle: String
    @Binding var itemDetail: String
    @Binding var currentProject: Project
    var message: String
    var body: some View {
        VStack {
            Text(message)
            Spacer()
            TextField("Task name".localized, text: $itemTitle)
            TextField("Description".localized, text: $itemDetail)
            Divider()
            HStack {
                Button {
                    showAddItem.toggle()
                } label: {
                    Text("Close".localized)
                }
                .frame(width: UIScreen.main.bounds.width/2 - 30, height: 44)
                .foregroundColor(.white)
                Button {
                    print("**** \(currentProject)")
                } label: {
                    Text("Ok".localized)
                }
                .frame(width: UIScreen.main.bounds.width/2 - 30, height: 44)
                .foregroundColor(.white)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 50, height: 200)
        .background(Color.midnight.opacity(0.5))
        .cornerRadius(12)
        .clipped()
    }
}

struct AddItemAlertView_Previews: PreviewProvider {
    static var previews: some View {
//        AddItemAlertView(showAddItem: .constant(true), message: "Test")
        AddItemAlertView(showAddItem: .constant(true), itemTitle: .constant("Title"), itemDetail: .constant("Detail"), currentProject: .constant(Project.example), message: "Test")
    }
}
