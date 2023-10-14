//
//  PHAssetExtension.swift
//  Project1
//
//  Created by NguyenHao on 14/10/2023.
//

import UIKit
import Photos

public extension PHAsset {
    func toImage() -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: self, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}
