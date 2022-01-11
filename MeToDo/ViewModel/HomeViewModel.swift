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
        private var projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>

        @Published var projects = [Project]()
        @Published var items = [Item]()
        @Published var selectedItem: Item?

        var dataController: DataController

        @Published var upNext = ArraySlice<Item>()
        @Published var moreToExplore = ArraySlice<Item>()
        
        @Published var selectedDateProject = [Project]()

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
            //            let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
            //
            //            let completedPredicate = NSPredicate(format: "completed = false")
            //            let openPredicate = NSPredicate(format: "project.closed = false")
            //            let compoundPredicate = NSCompoundPredicate(type: .and,
            //        subpredicates: [completedPredicate, openPredicate])
            //            itemRequest.predicate = compoundPredicate
            //            itemRequest.predicate = NSPredicate(format: "completed = false AND project.closed = false")
            //
            //            itemRequest.sortDescriptors = [
            //                NSSortDescriptor(keyPath: \Item.priority, ascending: false)
            //            ]
            //
            //            itemRequest.fetchLimit = 10
            let itemRequest = dataController.fetchRequestForTopItems(count: 10)

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

                // Updates HomeList
                upNext = items.prefix(3)
                moreToExplore = items.dropFirst(3)
                
            } catch {
                print("Failed to fetch")
            }
        }  //: init

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            items = itemsController.fetchedObjects ?? []
            // Updates HomeList
            upNext = items.prefix(3)
            moreToExplore = items.dropFirst(3)

            projects = projectsController.fetchedObjects ?? []
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }

        func selectedItem(with identifier: String) {
            selectedItem = dataController.item(with: identifier)
        }
        
        func selectedDateProj(selectedDate: Date) {
            print(selectedDate)
           let dateProjRequest = dataController.fetchSelectedDateProject(date: selectedDate)
            print("dateProjRequest is \(dateProjRequest.description)")
            projectsController = NSFetchedResultsController(
                fetchRequest: dateProjRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            print(("projectcontroller is \(projectsController.description)"))
            selectedDateProject = projectsController.fetchedObjects ?? []
            print(selectedDateProject.description)
        }
    }
    
    func fetchDateProject(selectedDate :Date) -> [Project] {
        let fetchRequest : NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", selectedDate as NSDate, selectedDate + 86400 as NSDate)
        do {
            return try dataController.container.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
}
