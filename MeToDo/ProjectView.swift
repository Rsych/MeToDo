//
//  ProjectView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/14.
//

import UIKit
import SwiftUI

struct ProjectView: View {
    // MARK: - Properties
    static let openTag: Int = 1
    static let closedTag: Int = 3
    
    let showClosedProjects: Bool
    let projects: FetchRequest<Project>
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)], predicate: NSPredicate(format: "closed = %d", showClosedProjects), animation: .default)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section {
                        
                        ForEach(project.projectItems) { item in
                            NavigationLink(destination: EditItemView(item: item)) {
                            Text(item.itemTitle)
                            }
                        }
                    } header: {
                        Text(project.projectTitle)
                            .foregroundColor(.primary)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.bottom, 3)
                }
            }  //: List
            .listStyle(SidebarListStyle())
            .navigationTitle(showClosedProjects ? "Finished" : "Open")
            .navigationBarTitleDisplayMode(.inline)
        }  //: NavView
    }  //: Body
}

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectView(showClosedProjects: true)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
