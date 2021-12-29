//
//  SharedItem.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/29.
//

import Foundation

struct SharedItem: Identifiable {
    let id: String
    let title: String
    let detail: String
    let completed: Bool
}
