//
//  DetailsViewController.swift
//  Project1
//
//  Created by VO ANH TRUONG on 14/10/2023.
//

import UIKit

class DetailsViewController: BaseViewController {
    @IBOutlet private(set) weak var collectionView: BaseCollectionView!
    
    var assetPhotoModels: [AssetPhotoModel] = []
    var index: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupView() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(AlbumCollectionViewCell.nib, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        
        
        self.collectionView.performBatchUpdates(nil) { [self] (isLoded) in
            if isLoded {
                collectionView.setContentOffset(.init(x: Int(UIScreen.main.bounds.width) * index!.row, y: 0), animated: false)
            }
        }
        
    }
}

extension DetailsViewController: UICollectionViewDelegate {
    
}

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assetPhotoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = assetPhotoModels[safe: indexPath.row]?.asset.toImage()
        cell.imageView.contentMode = .scaleAspectFit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.00000001
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.000000001
    }
    
}
