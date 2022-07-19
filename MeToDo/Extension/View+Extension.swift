//
//  View+Extension.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2022/07/20.
//

import Foundation
import UIKit
import SwiftUI

extension View {

    public func textFieldAlert(
        isPresented: Binding<Bool>,
        title: String,
        itemTitle: String = "",
        itemTitlePlaceHolder: String = "",
        itemDetail: String = "",
        itemDetailPlaceHolder: String = "",
        action: @escaping ([String]?) -> Void
    ) -> some View {
        self.modifier(TextFieldAlertModifier(isPresented: isPresented, title: title, itemTitle: itemTitle, itemTitlePlaceholder: itemTitlePlaceHolder, itemDetail: itemDetail, itemDetailPlaceholder: itemDetailPlaceHolder, action: action))
    }

}
