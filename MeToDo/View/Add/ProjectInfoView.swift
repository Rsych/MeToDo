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
            TextField("What to do?", text: $title)
            TextField("Description", text: $detail)
        } header: {
            Text("Basic settings")
        } // section 1
    }
}
