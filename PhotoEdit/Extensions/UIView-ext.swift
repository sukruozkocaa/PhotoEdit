//
//  UIView-ext.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 20.12.2022.
//

import Foundation
import UIKit

extension UIView {
    func edgesToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview!.topAnchor),
            bottomAnchor.constraint(equalTo: superview!.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview!.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview!.trailingAnchor)
        ])
    }

    func edgesToSuperviewSafeLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func edgesToSuperviewBoundsWithAutoResizingMask() {
        translatesAutoresizingMaskIntoConstraints = true
        frame = superview!.bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
