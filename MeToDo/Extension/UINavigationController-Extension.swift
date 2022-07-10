//
//  UINavigationController-Extension.swift
//  MeToDo
//
//  Created by Ryan J. W. Kim on 2022/03/16.
//
import SwiftUI

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
