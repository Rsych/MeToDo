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
        title ?? ""
    }
    var itemDetail: String {
        detail ?? ""
    }
    var itemCreationDate: Date {
        creationDate ?? Date()
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
    var projectTitle: String {
        title ?? ""
    }
    var projectDetail: String {
        detail ?? ""
    }
    var projectColor: String {
        color ?? "Orange"
    }
    
    var projectItems: [Item] {
        let itemsArray = items?.allObjects as? [Item] ?? []
        return itemsArray.sorted { first, second in
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
        
        return project
    }
}
