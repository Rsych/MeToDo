//
//  TabBarView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/13.
//

import SwiftUI

struct TabBarView: View {
    // MARK: - Properties
    @Binding var selectedTab: Int
    @Namespace private var currentTab
    // MARK: - Body
    var body: some View {
        HStack {
            ForEach(tabs.indices) { index in
                GeometryReader { geo in
                    VStack(spacing: 4) {
                        if selectedTab == index {
                            Color(.label)
                                .frame(height: 2)
                                .offset(y: -4)
                                .matchedGeometryEffect(id: "currentTab", in: currentTab)
                        }
                        Image(systemName: tabs[index].image)
                            .frame(height: 20)

                            // tilt image at select, not useful now
//                        if tabs[selectedTab].label == "Finished" && tabs[index].label == "Finished" {
//                            Image(systemName: tabs[index].image)
//                                .frame(height: 20)
//                                .rotationEffect(.degrees(25))
//                        } else {
//                            Image(systemName: tabs[index].image)
//                                .frame(height: 20)
//                                .rotationEffect(.degrees(0))
//                        } // tilt image

                        Text(tabs[index].label)
                            .font(.caption2)
                            .fixedSize()
                    }  //: VStack
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: geo.size.width / 2, height: 44, alignment: .bottom)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = index
                        }
                    }
                    .foregroundColor(selectedTab == index ? .primary : .secondary)
                }  //: GeoReader
                .frame(height: 88, alignment: .bottom)
            }  //: Tabs Loop
        }  //: HStack
        .background(.thickMaterial)
        .cornerRadius(25, corners: [.topLeft, .topRight])
    }  //: body
}

struct Tab {
    let image: String
    let label: String
}

let tabs = [
    Tab(image: "house.fill", label: "Home"),
    Tab(image: "list.bullet", label: "Open"),
    Tab(image: "plus.square.fill", label: "Add"),
    Tab(image: "checkmark", label: "Finished"),
    Tab(image: "person.2.fill", label: "Network")
]

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedTab: Binding.constant(0))
            .padding()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
//            .padding()
    }
}
