//
//  SharedProjectsView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/29.
//

import SwiftUI
import CloudKit

struct SharedProjectsView: View {
    // MARK: - Properties
    @State private var projects = [SharedProject]()
    @State private var loadState = LoadState.inactive
    // MARK: - Body
    var body: some View {
        NavigationView {
            Group {
                switch loadState {
                case .inactive, .loading:
                    ProgressView()
                case .noResult:
                    Text("No results")
                case .success:
                    List(projects) { project in
                        NavigationLink(destination: Color.blue) {
                            VStack(alignment: .leading) {
                                Text(project.title)
                                    .font(.headline)
                                Text(project.owner)
                            }  //: VStack
                        }  //: NavLink
                    }  //: Loop
                    .listStyle(InsetGroupedListStyle())
                }
            }  //: Group
            .navigationTitle("Shared Projects")
        }  //: NavView
        .onAppear(perform: fetchSharedProjects)
    }

    func fetchSharedProjects() {
        guard loadState == .inactive else { return }
        loadState = .loading

        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Project", predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["title", "detail", "owner", "closed"]
        operation.resultsLimit = 50

        operation.recordFetchedBlock = { record in
            let id = record.recordID.recordName
            let title = record["title"] as? String ?? "No title"
            let detail = record["detail"] as? String ?? ""
            let owner = record["owner"] as? String ?? "Anonymous"
            let closed = record["closed"] as? Bool ?? false

            let sharedProject = SharedProject(id: id, title: title, detail: detail, owner: owner, closed: closed)
            projects.append(sharedProject)
            loadState = .success
        }
    }
}

struct SharedProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        SharedProjectsView()
    }
}
