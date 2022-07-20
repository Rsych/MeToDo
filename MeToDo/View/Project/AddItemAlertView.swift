//
//  AddItemAlertView.swift
//  MeToDo
//
//  Created by Kim Jongwon on 2022/07/20.
//

import SwiftUI

struct AddItemAlertView: View {
    @Binding var showAddItem: Bool
    var message: String
    var body: some View {
        VStack {
            Text(message)
            Spacer()
            Divider()
            HStack {
                Button {
                    showAddItem.toggle()
                } label: {
                    Text("Close".localized)
                }
                .frame(width: UIScreen.main.bounds.width/2 - 30, height: 44)
                .foregroundColor(.white)
                Button {
                    
                } label: {
                    Text("Ok".localized)
                }
                .frame(width: UIScreen.main.bounds.width/2 - 30, height: 44)
                .foregroundColor(.white)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 50, height: 200)
        .background(Color.midnight.opacity(0.5))
        .cornerRadius(12)
        .clipped()
    }
}

struct AddItemAlertView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemAlertView(showAddItem: .constant(true), message: "Test")
    }
}
