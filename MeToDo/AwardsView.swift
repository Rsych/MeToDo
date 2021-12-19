//
//  AwardsView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/19.
//
// swiftlint:disable line_length

import SwiftUI

struct AwardsView: View {
    // MARK: - Properties
    static let awardsTag: Int = 4

    @State private var selectedAwards = Award.example
    @State private var showAwardsDetail = false

    @EnvironmentObject var dataController: DataController

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
                            selectedAwards = award
                            showAwardsDetail.toggle()
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(
                                    dataController.hasEarned(award: award) ? Color(award.color) : Color.secondary.opacity(0.5))
                        }  //: Award button
                    }  //: Award loop
                }  //: LazyVGrid
            }  //: ScrollView
            .navigationTitle("Awards")
        }  //: NavView
        .alert(isPresented: $showAwardsDetail) {
            if dataController.hasEarned(award: selectedAwards) {
                return Alert(title: Text("Achieved: \(selectedAwards.name)"), message: Text(selectedAwards.description), dismissButton: .default(Text("Ok")))
            } else {
                return Alert(title: Text("Locked: \(selectedAwards.name)"), message: Text(selectedAwards.description), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}
