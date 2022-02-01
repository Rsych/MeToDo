//
//  ProjectColorButtonView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/28.
//

import SwiftUI

struct ProjectColorButtonView: View {
    @Binding var color: String

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))]

    var body: some View {
        Section {
            LazyVGrid(columns: colorColumns) {
                ForEach(Project.colors, id: \.self) { item in
                    colorLoop(item: item)
                }  //: Color loop
            }  //: LazyVGrid
            .padding(.vertical)
            .listRowBackground(Color(uiColor: .systemFill))
            .foregroundColor(Color.primary)
        } header: {
            Text("Choose color")
        } // section 2
    }
}

struct ProjectColorButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectColorButtonView(color: .constant("Orange"))
    }
}

extension ProjectColorButtonView {
    private func colorLoop(item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)
            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }  //: ZStack
        .onTapGesture {
            color = item
        }
    }
}
