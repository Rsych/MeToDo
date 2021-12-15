//
//  Test.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/15.
//

import SwiftUI

class NavigationManager: ObservableObject{
    @Published private(set) var dest: AnyView? = nil
    @Published var isActive: Bool = false

    func move(to: AnyView) {
        self.dest = to
        self.isActive = true
    }
}

struct StackOverflow6: View {
    @State var showModal: Bool = false
    @EnvironmentObject var navigationManager: NavigationManager
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: self.navigationManager.dest, isActive: self.$navigationManager.isActive) {
                    EmptyView()
                }

                Button(action: {
                    self.showModal.toggle()
                }) {
                    Text("Show Modal")
                }
            }
        }
            .sheet(isPresented: self.$showModal) {
                secondView(isPresented: self.$showModal).environmentObject(self.navigationManager)
            }
    }
}

struct StackOverflow6_Previews: PreviewProvider {
    static var previews: some View {
        StackOverflow6().environmentObject(NavigationManager())
    }
}


struct secondView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Binding var isPresented: Bool
    @State var dest: AnyView? = nil

    var body: some View {
        VStack {
            Text("Modal view")
            Button(action: {
                self.isPresented = false
                self.dest = AnyView(thirdView())
            }) {
                Text("Press me to navigate")
            }
        }
        .onDisappear {
            // This code can run any where but I placed it in `.onDisappear` so you can see the animation
            if let dest = self.dest {
                self.navigationManager.move(to: dest)
            }
        }
    }
}

struct thirdView: View {
    var body: some View {
        Text("3rd")
            .navigationBarTitle(Text("3rd View"))
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        StackOverflow6()
    }
}
