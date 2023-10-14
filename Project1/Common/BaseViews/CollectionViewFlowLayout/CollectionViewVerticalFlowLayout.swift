//
//  VerticalFlowLayout.swift
//  Project1
//
//  Created by NguyenHao on 14/10/2023.
//

import UIKit

public enum CollectionViewFlowLayoutState: Int  {
    case prepare = 0
    case calculated = 1
}

extension CollectionViewFlowLayoutState: Comparable {
    public static func < (lhs: CollectionViewFlowLayoutState, rhs: CollectionViewFlowLayoutState) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

public protocol CollectionViewFlowLayoutAble: NSObject {
    func widthContent() -> CGFloat
}

public final class CollectionViewVerticalFlowLayout: UICollectionViewFlowLayout, CollectionViewFlowLayoutAble {
    private var collectionViewFlowLayoutAttributedManager: CollectionViewLayoutAttributedManagerProtocol?
    private var state = CollectionViewFlowLayoutState.prepare

    public init(delegate: CollectionViewFlowLayoutDelegate?, collectionView: UICollectionView?) {
        super.init()
//        pinterestFlowLayoutAttributedManager = .init(delegate: delegate, collectionView: collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepare() {
        super.prepare()
        if state == .prepare {
            collectionViewFlowLayoutAttributedManager?.prepare()
            state = .calculated
        }
    }
    
    public override var collectionViewContentSize: CGSize {
        CGSize(width: collectionViewFlowLayoutAttributedManager?.widthContentSize() ?? 0.0,
               height: collectionViewFlowLayoutAttributedManager?.heightContentSize() ?? 0.0)
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        collectionViewFlowLayoutAttributedManager?.layoutAttributesForItem(at: indexPath)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return collectionViewFlowLayoutAttributedManager?.layoutAttributesForElements(in: rect)
    }
    
    public func widthContent() -> CGFloat {
        collectionViewFlowLayoutAttributedManager?.widthContentSize() ?? 0.0
    }
}

