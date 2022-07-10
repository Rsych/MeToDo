//
//  DismissSheetKey.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2022/03/07.
//

import SwiftUI

struct ShowingSheetKey: EnvironmentKey {
    static let defaultValue: Binding<Bool>? = nil
}

extension EnvironmentValues {
    var showingSheet: Binding<Bool>? {
        get { self[ShowingSheetKey.self] }
        set { self[ShowingSheetKey.self] = newValue }
    }
}
