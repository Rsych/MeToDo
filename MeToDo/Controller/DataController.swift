//
//  DataController.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/14.
//

import CoreData
import CoreSpotlight
import SwiftUI
import WidgetKit
import UIKit

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
class DataController: ObservableObject {
    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer
    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs.)
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        // For testing purposes, creates /dev/null which is destroyed when app is finished.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let groupID = "group.net.naolin.MeToDo"

            if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
                container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("Main.sqlite")
            }
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            // Automatically merge changes from iCloud
            self.container.viewContext.automaticallyMergesChangesFromParent = true

            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
            }
            #endif
        }
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        return dataController
    }()

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    /// Creates example projects and items to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for projectCounter in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(projectCounter)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()
            project.color = Project.colors.randomElement()

            for itemCounter in 1...5 {
                let item = Item(context: viewContext)
                item.title = "Item \(itemCounter)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.priority = Int16.random(in: 1...3)
                item.project = project
            }
        }
        try viewContext.save()
    }

    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because all our attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

//    func delete(_ object: NSManagedObject) {
//        let id = object.objectID.uriRepresentation().absoluteString
//
//        if object is Item {
//            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
//        } else {
//            CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])
//        }
//        container.viewContext.delete(object)
//    }

    func delete(_ object: Item) {
        let id = object.objectID.uriRepresentation().absoluteString
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])

        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequest1: NSFetchRequest< NSFetchRequestResult> = Item.fetchRequest()
        delete(fetchRequest1)

        let fetchRequest2: NSFetchRequest< NSFetchRequestResult> = Project.fetchRequest()
        delete(fetchRequest2)
    }

    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }

    // Awards count
    func count<T>(for fetchRequests: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequests)) ?? 0
    }

    func update(_ item: Item) {
        let itemID = item.objectID.uriRepresentation().absoluteString
        let projectID = item.project?.objectID.uriRepresentation().absoluteString

        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = item.itemTitle
        attributeSet.contentDescription = item.itemDetail

        let searchableItem = CSSearchableItem(
            uniqueIdentifier: itemID,
            domainIdentifier: projectID,
            attributeSet: attributeSet
        )

        CSSearchableIndex.default().indexSearchableItems([searchableItem])

        save()
    }

    func item(with uniqueIdentifier: String) -> Item? {
        guard let url = URL(string: uniqueIdentifier) else { return nil }
        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil

        }
        return try? container.viewContext.existingObject(with: id) as? Item
    }

    func fetchRequestForTopItems(count: Int) -> NSFetchRequest<Item> {
        // Construct a fetch request to show the top 10 priority from incomplete open projects
        let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()

        let completedPredicate = NSPredicate(format: "completed = false")
        let openPredicate = NSPredicate(format: "project.closed = false")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
        itemRequest.predicate = compoundPredicate
        itemRequest.predicate = NSPredicate(format: "completed = false AND project.closed = false")

        itemRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.priority, ascending: false)
        ]

        itemRequest.fetchLimit = count
        return itemRequest
    }
    // Fetch for widget
    func result<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
        return (try? container.viewContext.fetch(fetchRequest)) ?? []
    }
    
    func urlItem(with uniqueIdentifier: URL) -> Item? {

        guard let uniqueIdentifier = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: uniqueIdentifier) else {
            return nil
        }

        return try? container.viewContext.existingObject(with: uniqueIdentifier) as? Item
    }
    
}

