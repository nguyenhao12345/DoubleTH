//
//  ViewController.swift
//  Project1
//
//  Created by NguyenHao on 11/10/2023.
//

import UIKit

final class HomeViewController: BaseViewController {
    @IBOutlet private(set) var albumCollectionView: BaseCollectionView!
    
    private lazy var alumnCollectionViewLayout: CollectionViewVerticalFlowLayout = {
        let layout = CollectionViewVerticalFlowLayout(delegate: self, collectionView: self.albumCollectionView)
        return layout
    }()
    
    private var assetsLocalData: RequestAssetsLocalData = AssetsLocalDataHandler()
    
    
    private var assetPhotoModels: [AssetPhotoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPhotosInAlbum()
    }
    
    override func setupView() {
        setupAlbumnCollectionView()
    }
    
    private func fetchPhotosInAlbum() {
        assetsLocalData.getAlbum { [weak self] albums in
            guard let self = self,
                  let albums = albums?.firstObject else { return }
            self.assetsLocalData.fetchPhotosInAlbum(album: albums, page: 1) { [weak self] assets in
                guard let self = self else { return }
//                assets.enumerateObjects { asset, <#Int#>, <#UnsafeMutablePointer<ObjCBool>#> in
//                    <#code#>
//                }
//                assets.
//                self.assetPhotoModels
                assets.enumerateObjects { asset, _, _ in
                    self.assetPhotoModels.append(.init(asset: asset))
                    DispatchQueue.main.async {
                        self.albumCollectionView.reloadData()
                    }
                    
                }
            }
        }
    }
}

private extension HomeViewController {
    func setupAlbumnCollectionView() {
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        albumCollectionView.register(AlbumCollectionViewCell.nib, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assetPhotoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        print(assetPhotoModels[safe: indexPath.row]?.asset.toImage())
        cell.imageView.image = assetPhotoModels[safe: indexPath.row]?.asset.toImage()
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
}

extension HomeViewController: CollectionViewFlowLayoutDelegate {
    func marginHorizontal() -> CGFloat {
        4
    }
    
    func marginVertical() -> CGFloat {
        4
    }
    
    func numberColumnInCollection() -> Int {
        2
    }
    
    func heightForCell(at indexPath: IndexPath, widthCellOfContent: CGFloat) -> CGFloat {
//        guard let imageAtIndexPath = images[safe: indexPath.row] else { return 0.0 }
//        let ratioHeightPerWidth = imageAtIndexPath.size.height / imageAtIndexPath.size.width
//        return widthCellOfContent * ratioHeightPerWidth
        return UIScreen.main.bounds.width / 2
    }
}

extension HomeViewController {
    public class func instance() -> HomeViewController {
        HomeViewController()
    }
}
