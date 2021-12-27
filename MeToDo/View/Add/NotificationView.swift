//
//  NotificationView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/27.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var dataController: DataController
    @Binding var dueOn: Bool
    @Binding var dueDate: Date
    
    var body: some View {
        
        Section {
            Toggle("Add due date", isOn: $dueOn.animation())
            if dueOn {
                DatePicker("Pick a date", selection: $dueDate, displayedComponents: .date)
            }
        } header: {
            Text("Due date")
        }
        
    }
}
//
//struct NotificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationView()
//            .previewLayout(.sizeThatFits)
//    }
//}
