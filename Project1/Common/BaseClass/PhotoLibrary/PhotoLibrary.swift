//
//  PHPhotoLibrary.swift
//  Project1
//
//  Created by NguyenHao on 14/10/2023.
//

import UIKit
import Photos

public protocol RequestAssetsLocalData {
//    func fetchPhotosInAlbum(albumName: String)
//    func getAlbum() -> PHFetchResult<PHAssetCollection>?
    func getAlbum(completion: @escaping (PHFetchResult<PHAssetCollection>?) -> Void)
    func fetchPhotosInAlbum(album: PHAssetCollection, page: Int, completion: @escaping (PHFetchResult<PHAsset>) -> Void)
}

open class AssetsLocalDataHandler: NSObject, RequestAssetsLocalData {
    public override init() {
        super.init()
    }
    
    public func getAlbum(completion: @escaping (PHFetchResult<PHAssetCollection>?) -> Void)  {
            let photos = PHPhotoLibrary.authorizationStatus()
//                if photos == .notDetermined {
                    PHPhotoLibrary.requestAuthorization({status in
                        if status == .authorized{
                            let fetchOptions = PHFetchOptions()
                            fetchOptions.predicate = NSPredicate(format: "title = %@", "dir_003")
                            let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                            completion(albums)
                        } else {}
                    })
//                }
    //        if PHPhotoLibrary.authorizationStatus() != .authorized {
    //            // You may want to request authorization from the user here
    //            // This step is necessary to access the photo library
    //            return nil
    //        }
            
            // Fetch the album with the specified name
          
        }
        
    public func fetchPhotosInAlbum(album: PHAssetCollection, page: Int, completion: @escaping (PHFetchResult<PHAsset>) -> Void) {
            // Check if the app has access to the user's photo library
            // Fetch all the assets (photos) in the album
            let fetchOptions = PHFetchOptions()
            fetchOptions.fetchLimit = page * 10
            let assets = PHAsset.fetchAssets(in: album, options: nil)
            debugPrint("count asset = ", page, assets.count)
            // Iterate through the assets and do something with each photo
//            assets.enumerateObjects { asset, ,  in
//                // Here, you can access individual assets and perform actions
//                // For example, you can get the image data or display the image
//                // using UIImageView
//            }
        
        completion(assets)
//            assets.enumerateObjects { asset, _, _  in
//
//            }
        }
}
