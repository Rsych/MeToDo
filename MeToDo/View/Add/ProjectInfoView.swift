//
//  ProjectInfoView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/28.
//

import SwiftUI

struct ProjectInfoView: View {
    @Binding var title: String
    @Binding var detail: String
    var body: some View {
        Section {
            TextField("Project Name", text: $title)
            TextField("Description", text: $detail)
        } header: {
            Text("Basic settings")
        } // section 1
    }
}
// Use .modifier(DismissingKeyboard()) to dismiss keyboard 
struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}
