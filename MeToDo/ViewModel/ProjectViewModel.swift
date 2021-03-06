//
//  ProjectViewModel.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/25.
//

import Foundation
import CoreData

extension ProjectView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        let dataController: DataController

        var sortOrder = Item.SortOrder.automatic
        let showClosedProjects: Bool

        private let projectsController: NSFetchedResultsController<Project>
        @Published var projects = [Project]()

        init(dataController: DataController, showClosedProjects: Bool) {
            self.dataController = dataController
            self.showClosedProjects = showClosedProjects

            let request: NSFetchRequest<Project> = Project.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

            projectsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            super.init()
            projectsController.delegate = self

            do {
                try projectsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch projects")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }
//        func addItem(to project: Project) {
//                let item = Item(context: dataController.container.viewContext)
//                item.project = project
//                item.creationDate = Date()
//                item.priority = 2
//                item.completed = false
//                dataController.save()
//        }  //: addItem
        func addItem(to project: Project, title: String, detail: String, priority: Int = 2) {
                let item = Item(context: dataController.container.viewContext)
                item.title = title
                item.detail = detail
                item.project = project
                item.creationDate = Date()
                item.priority = Int16(priority)
                item.completed = false
                dataController.save()
        }  //: addItem
        func delete(_ offsets: IndexSet, project: Project) {
            let allItems = project.projectItems(using: sortOrder)

            for offset in offsets {
                let item = allItems[offset]
                dataController.delete(item)
            }
            dataController.save()
        }  //: delete
    }
}
