//
//  SignInView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2021/12/29.
//
// swiftlint:disable line_length

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    // MARK: - Properties
    enum SignInStatus {
        case unknown
        case authorized
        case failure(Error?)
    }

    @State private var status = SignInStatus.unknown
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    // MARK: - Body
    var body: some View {
        NavigationView {
            Group {
                switch status {
                case .unknown:
                    VStack(alignment: .leading) {
                        ScrollView {
                            Text("""
                                It is not necessary to sign in but for future updates will include community features, which will require you to sign in to enjoy full features.

                                We do not track your personal information; your name will be used only for display purposes.
                                """)
                        }  //: ScrollView

//                        Spacer()

                        SignInWithAppleButton(onRequest: configSignIn, onCompletion: completeSignIn)
                            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                            .frame(width: 44, height: 44)

                        Button {
                            close()
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    } //: VStack
                case .authorized:
                    Text("You're all set!")
                case .failure(let error):
                    if let error = error {
                        Text("Sorry, there was an error: \(error.localizedDescription)")
                    } else {
                        Text("Sorry, there was an error.")
                    }
                }  //: Status switch
            }  //: Group
            .navigationTitle("Sign in…")
        } //: NavView
    } //: body

    func configSignIn(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName]
    }

    func completeSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            // success
        case .failure(let error):
            // failure
        }
    }
    func close() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
