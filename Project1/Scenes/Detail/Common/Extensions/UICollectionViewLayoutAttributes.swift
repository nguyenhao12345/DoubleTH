//
//  UICollectionViewLayoutAttributes.swift
//  Project1
//
//  Created by NguyenHao on 14/10/2023.
//

import UIKit

extension UICollectionViewLayoutAttributes {
    public convenience init(forCellWith indexPath: IndexPath, frame: CGRect) {
        self.init(forCellWith: indexPath)
        self.frame = frame
    }
}
