//
//  UIResponder+Extensions.swift
//  TestApp1
//
//  Created by Артём Петросян on 14.09.2024.
//

import UIKit

extension UIResponder {
    /// Access parent controller
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
