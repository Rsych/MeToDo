//
//  MoreView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/30.
//

import SwiftUI
import BetterSafariView
import MessageUI
//import SafariServices

struct MoreView: View {
    // MARK: - Properties
    static let moreTag: Int = 4
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    @State var notificationIsOn = false
    
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = false
    
    @State private var showSafari = false
    
    @State var selectedURL = Constants.appNotice
    
    @State private var showEmail = false
    @State private var errorEmail = false
    @State private var result: Result<MFMailComposeResult, Error>?
    
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                Section {
                    customizationSection
                    security
                    appSettings
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
        //        .sheet(isPresented: $showSafari) {
        //            SafariView(url: URL(string: selectedURL)!)
        //        }
        .safariView(isPresented: $showSafari) {
            SafariView(
                url: URL(string: selectedURL)!,
                configuration: SafariView.Configuration(
                    entersReaderIfAvailable: false,
                    barCollapsingEnabled: true
                )
            )
                .preferredBarAccentColor(.clear)
                .preferredControlAccentColor(.accentColor)
                .dismissButtonStyle(.done)
        }  //: Safari Link Open
    }  //: body
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
    // MARK: - AppInfo, SafariView
    private var openNotice: some View {
        Button {
            selectedURL = Constants.appNotice
            showSafari.toggle()
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
            selectedURL = Constants.appFAQs
            showSafari.toggle()
            print(selectedURL)
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
            selectedURL = Constants.appTNC
            showSafari.toggle()
            print(selectedURL)
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
            selectedURL = Constants.appPrivacy
            showSafari.toggle()
            print(selectedURL)
        } label: {
            HStack {
                Text("Privacy Policy")
                Spacer()
                Image(systemName: "chevron.forward")
            }  //: HStack
        }  //: Privacy Button
    }
}
