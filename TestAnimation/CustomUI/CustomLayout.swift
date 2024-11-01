//
//  CustomLayout.swift
//  TestAnimation
//
//  Created by Кизим Илья on 01.11.2024.
//

import UIKit

final class CustomLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var numberOfColumns: Int = 2
    var cellPadding: CGFloat
    var cellHeights: [CGFloat]
    
    // MARK: - LifeCyrcle
    
    init(cellHeights: [CGFloat], cellPadding: CGFloat) {
        self.cellHeights = cellHeights
        self.cellPadding = cellPadding
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0, height: contentHeight)
    }
    
    override func prepare() {
        guard collectionView != nil else { return }
        preparing()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

// MARK: - ExtensionSetupUI

private extension CustomLayout {
    func preparing() {
        cache.removeAll()
        contentHeight = 0
        
        let columnWidth = ((collectionView?.bounds.width ?? 0) - (CGFloat(numberOfColumns - 1) * cellPadding)) / CGFloat(numberOfColumns)
        var xOffsets: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffsets.append(CGFloat(column) * (columnWidth + cellPadding))
        }
        var columnHeights: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<(collectionView?.numberOfItems(inSection: 0) ?? 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let width = columnWidth
            
            let isFirstColumn = indexPath.item % 2 == 0
            let height: CGFloat
            
            if isFirstColumn {
                height = cellHeights[(indexPath.item / 2) % cellHeights.count]
            } else {
                height = cellHeights[(indexPath.item / 2 + 1) % cellHeights.count]
            }
            
            let column = indexPath.item % numberOfColumns
            
            let frame = CGRect(x: xOffsets[column], y: columnHeights[column], width: width, height: height)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            
            columnHeights[column] += height + cellPadding
            contentHeight = max(contentHeight, columnHeights[column])
        }
    }
}
