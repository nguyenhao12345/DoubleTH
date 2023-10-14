//
//  Reusable.swift
//  Project1
//
//  Created by NguyenHao on 12/10/2023.
//

import UIKit

public protocol Reusable {
    static var identifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable {
    public static var identifier: String { return String(describing: Self.self) }
    public static var nib: UINib? { UINib(nibName: identifier, bundle: nil) }
}
