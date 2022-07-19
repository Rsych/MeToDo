//
//  TextFieldAlert.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2022/07/20.
//

import Foundation
import SwiftUI

public struct TextFieldAlertModifier: ViewModifier {

    @State private var alertController: UIAlertController?


    @Binding var isPresented: Bool

    let title: String
    let itemTitle: String
    let itemTitlePlaceholder: String
    let itemDetail: String
    let itemDetailPlaceholder: String
    let action: ([String]?) -> Void

    public func body(content: Content) -> some View {
        content.onChange(of: isPresented) { isPresented in
            if isPresented, alertController == nil {
                let alertController = makeAlertController()
                self.alertController = alertController
                guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                    return
                }
                scene.windows.first?.rootViewController?.present(alertController, animated: true)
            } else if !isPresented, let alertController = alertController {
                alertController.dismiss(animated: true)
                self.alertController = nil
            }
        }
    }

    private func makeAlertController() -> UIAlertController {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        controller.addTextField {
            $0.placeholder = self.itemTitlePlaceholder
            $0.text = self.itemTitle
        }
        controller.addTextField {
            $0.placeholder = self.itemDetailPlaceholder
            $0.text = self.itemDetail
        }
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            shutdown()
        })
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.action([controller.textFields![0].text!, controller.textFields![1].text!])
            shutdown()
        }

        controller.addAction(okAction)
        return controller
    }

    private func shutdown() {
        isPresented = false
        alertController = nil
    }
}
