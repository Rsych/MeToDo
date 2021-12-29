//
//  SharedProject.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/29.
//

import Foundation

struct SharedProject: Identifiable {
    let id: String
    let title: String
    let detail: String
    let owner: String
    let closed: Bool

    static let example = SharedProject(id: "1", title: "Example", detail: "Detail", owner: "Ryan Sim", closed: false)
}
