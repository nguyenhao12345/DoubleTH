//
//  CollectionExtension.swift
//  Project1
//
//  Created by NguyenHao on 12/10/2023.
//

import Foundation

extension Collection {
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
