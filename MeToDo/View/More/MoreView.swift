//
//  MoreView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/30.
//

import SwiftUI
import BetterSafariView
import MessageUI

@MainActor
struct MoreView: View {
    // MARK: - Properties
    static let moreTag: Int = 4
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    @State var notificationIsOn = false
    
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = false
    
    @State private var showSafari = false
    
    @State private var selectedURL: String?
    
    @State private var showEmail = false
    @State private var errorEmail = false
    @State private var result: Result<MFMailComposeResult, Error>?
    @State private var showDeleteAlert = false
    
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                Section {
                    customizationSection
                    security
                    appSettings
                    deleteAll
                }  //: First section Customization
                .padding()
                .listRowSeparator(.hidden)
                
                Spacer()
                
                Section {
                    openNotice
                    openFAQ
                    appRating
                    sendEmail
                    termsAndConditions
                    privacyPolicy
                    
                    // Custom line separator
                    Rectangle().fill(Color.primary).frame(maxWidth: .infinity, maxHeight: 1, alignment: .leading)
                    
                } footer: {
                    Text("Version \(Bundle.main.appVersionShort)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }  //: Second section
                .padding()
                .listRowSeparator(.hidden)
            }  //: List
            .listStyle(.plain)
            .padding(.bottom, 44)
            .navigationTitle("More")
        }  //: NavView
        .sheet(isPresented: $showSafari) {
            if let selectedURL = selectedURL {
                SafariView(url: URL(string: selectedURL)!)
            }
        }
    }  //: body
    private func openLink(_ url: String) {
        selectedURL = url
        DispatchQueue.main.async {
            self.showSafari = true
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        MoreView()
    }
}

//struct SafariView: UIViewControllerRepresentable {
//
//    let url: URL
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
//        return SFSafariViewController(url: url)
//    }
//
//    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
//
//    }
//
//}

extension MoreView {
    // MARK: - App customization
    private var customizationSection: some View {
        ZStack {
            HStack {
                Text("Customization")
                Spacer()
                Image(systemName: "chevron.forward")
            }
            NavigationLink {
                CustomizationView(darkModeEnabled: $darkModeEnabled, systemThemeEnabled: $systemThemeEnabled)
            } label: {
                EmptyView()
            }
            .opacity(0.0)
        }  //: Customization ZStack
    }
    
    private var security: some View {
        ZStack {
            HStack {
                Text("Face ID / Passcode")
                Spacer()
                Image(systemName: "chevron.forward")
            }
            
            NavigationLink {
                SecurityView()
            } label: {
                EmptyView()
            }
            .opacity(0.0)
        }  //: Customization ZStack
    }
    private var appSettings: some View {
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
    private var deleteAll: some View {
        Button {
            showDeleteAlert.toggle()
        } label: {
            HStack {
                Text("Delete All")
                Spacer()
                Image(systemName: "chevron.forward")
            }  //: HStack
        } .tint(.primary)
            .alert("Delete All", isPresented: $showDeleteAlert) {
                Button("Delete All", role: .destructive) {
                    dataController.deleteAllDataFromICloud()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will delete all data and it is not reversible!")
            }
    }
    // MARK: - AppInfo, SafariView
    private var openNotice: some View {
        Button {
            openLink(Constants.appNotice)
        } label: {
            HStack {
                Text("Notice")
                Spacer()
                Image(systemName: "chevron.forward")
            }  //: HStack
        }  //: Notice button
    }
    private var openFAQ: some View {
        Button {
            openLink(Constants.appFAQs)
        } label: {
            HStack {
                Text("FAQ")
                Spacer()
                Image(systemName: "chevron.forward")
            }  //: HStack
        }  //: FAQ button
    }
    private var appRating: some View {
        Button {
            dataController.showReview()
        } label: {
            HStack {
                Text("Leave a rating")
                Spacer()
                Image(systemName: "chevron.forward")
            }  //: HStack
        }  //: Store Rating button
    }
    private var sendEmail: some View {
        Button {
            if MFMailComposeViewController.canSendMail() {
                self.showEmail.toggle()
            } else {
                print("Error")
                self.errorEmail.toggle()
            }
        } label: {
            HStack {
                Text("Contact us")
                Spacer()
                Image(systemName: "chevron.forward")
            }  //: HStack
        }  //: Contact us email button
        
        .sheet(isPresented: $showEmail) {
            MailView(result: self.$result, newSubject: Constants.subject, newMsgBody: Constants.msgBody)
        }  //: Show Email composer sheet
        
        .alert(isPresented: $errorEmail) {
            Alert(
                title: Text("Error"),
                message: Text("Can't send email now, check your network connection and try again"),
                dismissButton: .default(Text("Ok")))
        }  //: Email error Alert
    }
    private var termsAndConditions: some View {
        Button {
            openLink(Constants.appTNC)
        } label: {
            HStack {
                Text("Terms")
                Spacer()
                Image(systemName: "chevron.forward")
            }  //: HStack
        }  //: Terms Button
    }
    private var privacyPolicy: some View {
        Button {
            openLink(Constants.appPrivacy)
        } label: {
            HStack {
                Text("Privacy Policy")
                Spacer()
                Image(systemName: "chevron.forward")
            }  //: HStack
        }  //: Privacy Button
    }
}
