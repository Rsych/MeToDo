//
//  ProjectHeaderView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/15.
//

import SwiftUI

struct ProjectHeaderView: View {
    // MARK: - Properties
    @ObservedObject var project: Project

    @State private var selectedProject: FetchedResults<Project>.Element?

//    @State private var showModal = false
    // MARK: - Body
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)
                    .fontWeight(.bold)

                ProgressView(value: project.completionAmount)
                    .tint(Color(project.projectColor))
            }
            Spacer()

                Image(systemName: "pencil")
                .onTapGesture {
//                    showModal.toggle()
                    self.selectedProject = project
                }
        }  //: HStack
        .padding(.bottom, 10)
//        .sheet(isPresented: $showModal) {
//            EditProjectView(project: project)
//        }
        .sheet(item: $selectedProject) {
            EditProjectView(project: $0)
        }
    }  //: body
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
            .previewLayout(.sizeThatFits)
    }
}
