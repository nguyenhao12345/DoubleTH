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
    
    private(set) var arrayAlbumModel: [AlbumModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testRequest()
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

//MARK: request API
extension HomeViewController: SendingAPIRequestInteractionsAble {
     private func testRequest() {
        self.sendRequest(.init(endpoint: .test, method: .get)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let data = data else { return }
                do {
                    if let array: [[String: Any]] = try data.parser() {
                        self.loadArrayAlbumnOnSuccess(with: array)
                    } else {
                        
                    }
                } catch {
                    break
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func loadArrayAlbumnOnSuccess(with array: [[String: Any]]) {
        arrayAlbumModel = array.map { .init(with: $0) }
        albumCollectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayAlbumModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        if let albumAtIndexPath = arrayAlbumModel[safe: indexPath.row] {
            cell.config(with: albumAtIndexPath.title, image: arrayImagesGlobal[albumAtIndexPath.thumbnailUrl] ?? UIImage())
            
//            if arrayImagesGlobal[albumAtIndexPath.thumbnailUrl] == nil {
//                let operationQueue = OperationQueue()
//                let operation = ImageDownloader(urlAsText: albumAtIndexPath.thumbnailUrl)
//                operationQueue.addOperation(operation)
//                operation.completionBlock = {
//                    DispatchQueue.main.async {
//                        collectionView.reloadItems(at: [indexPath])
//                        print(indexPath)
//                    }
//                }
//            }
        }
        
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
