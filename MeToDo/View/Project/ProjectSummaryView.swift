//
//  ProjectSummaryView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/23.
//

import SwiftUI

struct ProjectSummaryView: View {
    @ObservedObject var project: Project
    @State private var selectedProject: FetchedResults<Project>.Element?

    var body: some View {
        Button {
            self.selectedProject = project
        } label: {
        VStack(alignment: .leading) {
            Text("\(project.projectItems.count) items")
                .font(.caption)
                .foregroundColor(.secondary)
            // Add ProjectInfoView later
            Text(project.projectTitle)
                .font(.title2)
                .foregroundColor(.primary)

            ProgressView(value: project.completionAmount)
                .tint(Color(project.projectColor))
        }  //: VStack
        .padding()
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: .primary.opacity(0.2), radius: 3)
        }
        .sheet(item: $selectedProject) {
            EditProjectView(project: $0)
        }
    }
}

// struct ProjectSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectSummaryView()
//    }
// }
