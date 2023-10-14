//
//  ViewController.swift
//  Project1
//
//  Created by NguyenHao on 11/10/2023.
//

import UIKit
import Photos

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
        assetsLocalData.getImages(from: "dir_003") { [weak self] assets in
            guard let self = self else { return }
            assets.enumerateObjects { asset, _, _ in
                self.assetPhotoModels.append(.init(asset: asset))
            }
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.albumCollectionView.reloadData()
                weakSelf.alumnCollectionViewLayout.reload()
            }
        }
    }
}

private extension HomeViewController {
    func setupAlbumnCollectionView() {
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        albumCollectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        albumCollectionView.collectionViewLayout = alumnCollectionViewLayout
        albumCollectionView.register(AlbumCollectionViewCell.nib, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assetPhotoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
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
        3
    }
    
    func heightForCell(at indexPath: IndexPath, widthCellOfContent: CGFloat) -> CGFloat {
        return 100
    }
}

extension HomeViewController {
    public class func instance() -> HomeViewController {
        HomeViewController()
    }
}
