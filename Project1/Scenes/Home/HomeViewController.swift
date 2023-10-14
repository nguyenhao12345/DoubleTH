//
//  ViewController.swift
//  Project1
//
//  Created by NguyenHao on 11/10/2023.
//

import UIKit

var arrayImagesGlobal: [String: UIImage] = [:]

final class HomeViewController: BaseViewController {
    @IBOutlet private(set) var albumCollectionView: BaseCollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func setupView() {
        setupAlbumnCollectionView()
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
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }

        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
}


extension HomeViewController {
    public class func instance() -> HomeViewController {
        HomeViewController()
    }
}
