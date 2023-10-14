//
//  AlbumCollectionViewCell.swift
//  Project1
//
//  Created by NguyenHao on 12/10/2023.
//

import UIKit

final class AlbumCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var imageView: UIImageView!
    
    func config(with title: String, image: UIImage) {
        titleLabel.text = title
        imageView.image = image
    }
}
