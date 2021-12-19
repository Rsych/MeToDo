//
//  AwardsView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/19.
//

import SwiftUI

struct AwardsView: View {
    // MARK: - Properties
    static let awardsTag: Int = 4
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            // actions
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.secondary.opacity(0.5))
                        }  //: Award button
                    }  //: Award loop
                }  //: LazyVGrid
            }  //: ScrollView
            .navigationTitle("Awards")
        }  //: NavView
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}
