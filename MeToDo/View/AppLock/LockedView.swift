//
//  LockedView.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2022/01/09.
//

import SwiftUI

struct LockedView: View {
    @EnvironmentObject var appLockVM: AppLockViewModel
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                Text("잠금 해제")
                    .font(.title)
                    .fontWeight(.bold)
                Text("생체정보가 일치하면 잠금이 해제됩니다.")
                Spacer()
                Button {
                    appLockVM.appLockValidation()
                } label: {
                    Image(systemName: "faceid")
                        .font(.system(size: 88, weight: .regular))
                }
                Spacer()
            }
            // App coming from background
            // init lock validation
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                appLockVM.appLockValidation()
            }
        }  //: NavView
    }
}

struct LockedView_Previews: PreviewProvider {
    static var previews: some View {
        LockedView()
    }
}
