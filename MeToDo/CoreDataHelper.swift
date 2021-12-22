//
//  CoreDataHelper.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/14.
//

import Foundation
import UIKit

extension Item {
    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }
    var itemDetail: String {
        detail ?? ""
    }
    var itemCreationDate: Date {
        creationDate ?? Date()
    }

    enum SortOrder {
        case title, creationDate, automatic
    }

    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let item = Item(context: viewContext)
        item.title = "Example Item"
        item.detail = "Example item"
        item.priority = 2
        item.creationDate = Date()

        return item
    }
}

extension Project {
    static let colors = [
        "Pink", "Purple", "Red",
        "Orange", "Gold", "Green",
        "Teal", "Light Blue", "Dark Blue",
        "Midnight", "Dark Gray", "Gray"
    ]

    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }
    var projectDetail: String {
        detail ?? ""
    }
    var projectColor: String {
        color ?? "Orange"
    }

    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }
    var projectItemsDefaultSorted: [Item] {
        projectItems.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }
            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }
            return first.itemCreationDate < second.itemCreationDate
        }
    }

    func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title:
            return projectItems.sorted { $0.itemTitle < $1.itemTitle }
        case .creationDate:
            return projectItems.sorted { $0.itemCreationDate < $1.itemCreationDate }
        case .automatic:
            return projectItemsDefaultSorted
        }
    }

    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else { return 0 }

        let completedItems = originalItems.filter { $0.completed == true }
        //        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }

    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let project = Project(context: viewContext)
        project.title = "Example project"
        project.detail = "Example"
        project.closed = true
        project.creationDate = Date()
        project.color = colors.randomElement()

        return project
    }
}
