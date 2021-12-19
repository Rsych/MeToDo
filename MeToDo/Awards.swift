//
//  Award.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/19.
//

import Foundation

struct Awards: Decodable, Identifiable {
    var id: String { name }
    let name: String
    let description: String
    let color: String
    let criterion: String
    let value: Int
    let image: String

    static let allAwards = Bundle.main.decode([Awards].self, from: "Awards.json")
    static let example = allAwards[0]
}

/*
 "name": "First Steps",
 "description": "Add your first item.",
 "color": "Light Blue",
 "criterion": "items",
 "value": 1,
 "image": "figure.walk"
 */
