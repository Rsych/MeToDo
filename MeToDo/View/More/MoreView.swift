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
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    @State var notificationIsOn = false

    //    @Binding var darkModeEnabled: Bool
    //    @Binding var systemThemeEnabled: Bool
    // For later settings update
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = false
    @State private var action: Int? = 0

    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                Section {
                    ZStack {
                        HStack {
                            Text("Customization")
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }
                        NavigationLink {
                            SettingsView(darkModeEnabled: $darkModeEnabled, systemThemeEnabled: $systemThemeEnabled)
                        } label: {
                            EmptyView()
                        }
                        .opacity(0.0)
                    }

                    Button {
                        dataController.showAppSettings()
                    } label: {
                        HStack {
                            Text("App settings")
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }  //: HStack
                    } .tint(.primary)
                }
                .padding()
                .listRowSeparator(.hidden)
                Spacer()
                Section {
                    Link(destination: URL(string: "https://naver.com")!) {
                        HStack {
                            Text("Notice")
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }  //: HStack
                    }

                    Link(destination: URL(string: "https://naver.com")!) {
                        HStack {
                            Text("FAQ")
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }  //: HStack
                    }

                    Button(action: dataController.showReview) {
                        HStack {
                            Text("Leave a rating")
                            Spacer()
                            Image(systemName: "chevron.forward")
                        }  //: HStack
                    }

                    HStack {
                        Text("Contact us")
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }  //: HStack

                    HStack {
                        Text("Terms")
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }  //: HStack

                    // No need for Privacy now
                    //                HStack {
                    //                    Text("Privacy Policy")
                    //                    Spacer()
                    //                    Image(systemName: "chevron.forward")
                    //                }  //: HStack
                    Rectangle().fill(Color.primary).frame(maxWidth: .infinity, maxHeight: 1, alignment: .leading)
                } footer: {
                    Text("Version \(Bundle.main.appVersionShort)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
                .listRowSeparator(.hidden)
            }  //: List
            .listStyle(.plain)
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.inline)
        }  //: NavView
    }  //: body
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
