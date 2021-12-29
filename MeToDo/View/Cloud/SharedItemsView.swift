//
//  SharedItemsView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/29.
//

import SwiftUI
import CloudKit

struct SharedItemsView: View {
    // MARK: - Properties
    let project: SharedProject

    @State private var items = [SharedItem]()
    @State private var itemsLoadState = LoadState.inactive
    // MARK: - Body
    var body: some View {
        List {
            Section {
                switch itemsLoadState {
                case .inactive, .loading:
                    ProgressView()
                case .noResult:
                    Text("No results")
                case .success:
                    ForEach(items) { item in
                        Text(item.title)
                            .font(.headline)
                        if item.detail.isEmpty != true {
                            Text(item.detail)
                        }
                    }  //: Loop
                }
            }  //: Section
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(project.title)
            .onAppear {
                fetchSharedItems()
            }
        }  //: List
    }

    func fetchSharedItems() {
        guard itemsLoadState == .inactive else { return }
        itemsLoadState = .loading
        
        let recordID = CKRecord.ID(recordName: project.id)
        let reference = CKRecord.Reference(recordID: recordID, action: .none)
        let pred = NSPredicate(format: "project == %@", reference)
        let sort = NSSortDescriptor(key: "title", ascending: true)
        let query = CKQuery(recordType: "Item", predicate: pred)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["title", "detail", "completed"]
        operation.resultsLimit = 50
        
        operation.recordFetchedBlock = { record in
            let id = record.recordID.recordName
            let title = record["title"] as? String ?? "No title"
            let detail = record["detail"] as? String ?? ""
            let completed = record["completed"] as? Bool ?? false
            
            let sharedItem = SharedItem(id: id, title: title, detail: detail, completed: completed)
            items.append(sharedItem)
            itemsLoadState = .success
        }
        
        operation.queryCompletionBlock = { _, _ in
            if items.isEmpty {
                itemsLoadState = .noResult
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}

struct SharedItemsView_Previews: PreviewProvider {
    static var previews: some View {
        SharedItemsView(project: SharedProject.example)
    }
}
