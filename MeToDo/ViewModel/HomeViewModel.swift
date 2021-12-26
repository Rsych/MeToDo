//
//  HomeViewModel.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/26.
//

import Foundation
import CoreData

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>

        @Published var projects = [Project]()
        @Published var items = [Item]()

        var dataController: DataController

        var upNext: ArraySlice<Item> {
            items.prefix(3)
        }
        var moreToExplore: ArraySlice<Item> {
            items.dropFirst(3)
        }

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all open projects
            let projectRequests: NSFetchRequest<Project> = Project.fetchRequest()
            projectRequests.predicate = NSPredicate(format: "closed = false")
            projectRequests.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]

            projectsController = NSFetchedResultsController(
                fetchRequest: projectRequests,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

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

            itemRequest.fetchLimit = 10

            itemsController = NSFetchedResultsController(
                fetchRequest: itemRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            projectsController.delegate = self
            itemsController.delegate = self

            do {
                try projectsController.performFetch()
                try itemsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
                items = itemsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch")
            }
        }  //: init

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newItems = controller.fetchedObjects as? [Item] {
                items = newItems
            } else if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
    }
}
