//
//  CollectionViewVerticalFlowLayoutAttributedManager.swift
//  Project1
//
//  Created by NguyenHao on 14/10/2023.
//

import UIKit

public protocol CollectionViewFlowLayoutDelegate: AnyObject {
    func marginHorizontal() -> CGFloat
    func marginVertical() -> CGFloat
    func numberColumnInCollection() -> Int
    func heightForCell(at indexPath: IndexPath, widthCellOfContent: CGFloat) -> CGFloat
}

public protocol CollectionViewLayoutAttributedManagerProtocol {
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    func heightContentSize() -> CGFloat
    func widthContentSize() -> CGFloat
    func changeSize(with size: CGSize, at indexPath: IndexPath) -> Bool
    func prepare()
    func reload()
}

open class CollectionViewVerticalFlowLayoutAttributedManager: NSObject, CollectionViewLayoutAttributedManagerProtocol {
    enum Direction {
        case top
        case bottom
        case none
    }
    
    private weak var collectionView: UICollectionView?
    private var attributedsCached: [UICollectionViewLayoutAttributes] = []
    @RangeIntegerPropertyWapper(max: 6) var limitNumberColumnInCollection
    private weak var delegate: CollectionViewFlowLayoutDelegate?
    private var listIndexsInRectTermperator: [IndexPath] = []
    private lazy var scaningRect = CGRect(origin: .init(x: -(collectionView?.frame.width ?? 0),
                                                        y: -(collectionView?.frame.height ?? 0)),
                                          size: .init(width: 3 * (collectionView?.frame.width ?? 0),
                                                      height: 3 * (collectionView?.frame.height ?? 0)))
    
    private var maxY: CGFloat = 0
    private var minY: CGFloat = 0
    private var indexOfMaxY = 0
    private var indexOfMinY = 0
    private var indexLastCaculated = 0
    private var direction: Direction = .none
    private var prepareOnSuccesfully: Bool = false
    private var maxHeightCurrent: CGFloat {
        attributedsCached.last?.frame.maxY ?? 0.0
    }
    public func reload() {
        initValues()
    }
    
    public init?(delegate: CollectionViewFlowLayoutDelegate?, collectionView: UICollectionView?) {
        guard let collectionView = collectionView,
              let delegate = delegate else { return nil }
        self.collectionView = collectionView
        self.delegate = delegate
    }
    
    public func prepare() {
        guard let collectionView = collectionView else { return }
        limitNumberColumnInCollection = delegate?.numberColumnInCollection()
        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections {
            prepareSection(at: section)
        }
    }

    public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        attributedsCached[safe: indexPath.row]
    }
    
    public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if scaningRect.maxY > rect.maxY {
            direction = .top
        } else {
            direction = .bottom
        }
        scaningRect = rect
        
        let numberOfSections = collectionView?.numberOfSections ?? 0
        listIndexsInRectTermperator = []
        minY = rect.maxY
        maxY = rect.minY
        for section in 0..<numberOfSections {
            prepareSection(at: section)
        }
        
        return listIndexsInRectTermperator.compactMap { attributedsCached[safe: $0.row] }
    }
    
    public func heightContentSize() -> CGFloat {
        if attributedsCached.isEmpty { return 0 }
        let padding = collectionView?.contentInset ?? .init()
        return (attributedsCached.last?.frame.maxY ?? 0) + padding.top + padding.bottom
    }
    
    public func widthContentSize() -> CGFloat {
        let padding = collectionView?.contentInset ?? .init()
        return (collectionView?.frame.width ?? 0.0) - (padding.left + padding.right)
    }
    
    public func changeSize(with size: CGSize, at indexPath: IndexPath) -> Bool {
        return true
    }
}

private extension CollectionViewVerticalFlowLayoutAttributedManager {
    private func initValues() {
        limitNumberColumnInCollection = delegate?.numberColumnInCollection()
        attributedsCached = []
        scaningRect = CGRect(origin: .init(x: -(collectionView?.frame.width ?? 0),
                                                            y: -(collectionView?.frame.height ?? 0)),
                                              size: .init(width: 3 * (collectionView?.frame.width ?? 0),
                                                          height: 3 * (collectionView?.frame.height ?? 0)))
        maxY = 0
        minY = 0
        indexOfMaxY = 0
        indexOfMinY = 0
        indexLastCaculated = 0
        prepareOnSuccesfully = false
    }
    
    private func prepareSection(at sectionIndex: Int) {
        guard let collectionView = collectionView else { return }
        let numberOfItems = collectionView.numberOfItems(inSection: sectionIndex)
        
        if !prepareOnSuccesfully {
            for index in 0..<numberOfItems {
                let indexPath = IndexPath(row: index, section: sectionIndex)
                let cellAtIndex: UICollectionViewLayoutAttributes

                cellAtIndex = prepareCell(at: sectionIndex,
                                          rowIndex: index)
                maxY = max(maxY, cellAtIndex.frame.maxY)

                attributedsCached.append(cellAtIndex)
                listIndexsInRectTermperator.append(indexPath)

                if maxY >= scaningRect.maxY {
                    break
                }
                indexLastCaculated = index
                indexOfMaxY = index
            }
            prepareOnSuccesfully = true
        }
        else {
            switch direction {
            case .top:
                var updated = false

                for index in (0...indexOfMaxY).reversed() {
                    let indexPath = IndexPath(row: index, section: sectionIndex)
                    let cellAtIndex: UICollectionViewLayoutAttributes

                        cellAtIndex = prepareCell(at: sectionIndex,
                                                    rowIndex: index)
                    if let attributedsCachedLast = attributedsCached.last,
                       indexPath.row > attributedsCachedLast.indexPath.row {
                        attributedsCached.append(cellAtIndex)
                    }


                    if !listIndexsInRectTermperator.contains(indexPath) {
                        listIndexsInRectTermperator.append(indexPath)
                    }
                    minY = min(minY, cellAtIndex.frame.minY)
                    if cellAtIndex.frame.minY < scaningRect.maxY {
                        if !updated {
                            updated = true
                            if cellAtIndex.frame.minY < scaningRect.minY {
                                break
                            }
                        } else {
                            if cellAtIndex.frame.minY < scaningRect.minY {
                                break
                            } else {
                                indexOfMinY = index
                            }
                        }
                    } else {
                        indexOfMaxY = index
                    }
                }

            case .bottom:
                var updated = false

                for index in indexOfMinY..<numberOfItems {
                    let indexPath = IndexPath(row: index, section: sectionIndex)
                    let cellAtIndex: UICollectionViewLayoutAttributes

                        cellAtIndex = prepareCell(at: sectionIndex,
                                                    rowIndex: index)
                    if let attributedsCachedLast = attributedsCached.last,
                       indexPath.row > attributedsCachedLast.indexPath.row {
                        attributedsCached.append(cellAtIndex)
                    }

                    if !listIndexsInRectTermperator.contains(indexPath) {
                        listIndexsInRectTermperator.append(indexPath)
                    }

                    maxY = max(maxY, cellAtIndex.frame.maxY)
                    if cellAtIndex.frame.maxY > scaningRect.minY {
                        if !updated {
                            updated = true
                            if cellAtIndex.frame.maxY > scaningRect.maxY {
                                break
                            }
                        } else {
                            if cellAtIndex.frame.maxY > scaningRect.maxY {
                                break
                            } else {
                                indexOfMaxY = index
                            }
                        }
                    } else {
                        indexOfMinY = index
                    }


                }
            case .none:
                print("nothing")
            }
        }
        
    }
    
    private func prepareCell(at sectionIndex: Int,
                             rowIndex: Int) -> UICollectionViewLayoutAttributes {
        let indexColumnCurrent = rowIndex % (limitNumberColumnInCollection ?? 0)
        let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
        let sizeOfCell = sizeForCell(at: indexPath)
        let marginHorical: CGFloat = indexColumnCurrent == 0 ? 0 : CGFloat(rowIndex % (limitNumberColumnInCollection ?? 0))
        let marginVertical: CGFloat = CGFloat((rowIndex) / (limitNumberColumnInCollection ?? 0)) == 0 ? 0 : CGFloat((rowIndex) / (limitNumberColumnInCollection ?? 0)) * (delegate?.marginVertical() ?? 0)
        let frameCaculator: CGRect
        
        if let framePriviousCache = attributedsCached[safe: rowIndex] {
            return framePriviousCache
        }
        else {
            let locationY: CGFloat = CGFloat((rowIndex) / (limitNumberColumnInCollection ?? 0)) * (sizeOfCell?.height ?? 0) + marginVertical
            let locationX: CGFloat = CGFloat(rowIndex % (limitNumberColumnInCollection ?? 0)) * (sizeOfCell?.width ?? 0) + marginHorical
            frameCaculator = .init(x: locationX,
                                   y: locationY,
                                   width: sizeOfCell?.width ?? 0,
                                   height: sizeOfCell?.height ?? 0)
        }

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath, frame: frameCaculator)
        return attributes
    }
    
    private func sizeForCell(at indexPath: IndexPath) -> CGSize? {
        guard let limitNumberColumnInCollection = limitNumberColumnInCollection,
              let numberColumnInCollection = delegate?.numberColumnInCollection() else { return nil }
        if numberColumnInCollection < 0 || numberColumnInCollection > limitNumberColumnInCollection {
            return nil
        }
        let padding = collectionView?.contentInset ?? .init()
        let marginHorical = delegate?.marginHorizontal() ?? 0
        let widthOfCollectionView = collectionView?.frame.width ?? 0
        let widthContent = widthOfCollectionView - ((CGFloat(numberColumnInCollection) - 1) * marginHorical) - (padding.left + padding.right)
        let width = numberColumnInCollection == 0 ? 0 : (widthContent / CGFloat(numberColumnInCollection))
        let height = delegate?.heightForCell(at: indexPath, widthCellOfContent: width)
        return .init(width: width, height: height ?? 0)
    }
    
    private func widthContent() -> CGFloat {
        guard let numberColumnInCollection = delegate?.numberColumnInCollection() else { return 0 }
        let padding = collectionView?.contentInset ?? .init()
        let marginHorical = delegate?.marginHorizontal() ?? 0
        let widthOfCollectionView = collectionView?.frame.width ?? 0
        let widthContent = widthOfCollectionView - ((CGFloat(numberColumnInCollection) - 1) * marginHorical) - (padding.left + padding.right)
        return widthContent
    }
}

