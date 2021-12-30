//
//  MoreView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/30.
//

import SwiftUI

struct MoreView: View {
    // MARK: - Properties
    static let moreTag: Int = 4
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = false

    // MARK: - Body
    var body: some View {
        NavigationView {
            Text("More VIew")
                .navigationTitle("More")
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SettingsView(darkModeEnabled: $darkModeEnabled, systemThemeEnabled: $systemThemeEnabled)
                        } label: {
                            Image(systemName: "gear")
                                .tint(.primary)
                        }
                    }
                }
        }  //: NavView
    }  //: body
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
