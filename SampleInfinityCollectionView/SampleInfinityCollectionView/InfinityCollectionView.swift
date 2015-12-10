//
//  InfinityCollectionView.swift
//  SampleInfinityCollectionView
//
//  Created by nagisa-kosuge on 2015/12/10.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

class InfinityCollectionView: UICollectionView {
    
    /// 表示するCellの数を増大させる比率
    var factor: Int = 1
    private var needsScrollToCenter: Bool = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutRecenter()
        
        if contentSize.width > 0.0 && needsScrollToCenter {
            var i: Int = 0
            var x: CGFloat = 0.0
            while i <= 0 {
                let indexPath = NSIndexPath(forItem: i, inSection: 0)
                guard let attribute = collectionViewLayout.layoutAttributesForItemAtIndexPath(indexPath) else {
                    break
                }
                var minimumInteritemSpacing: CGFloat = 0.0
                if let delegateFlowLayout = delegate as? UICollectionViewDelegateFlowLayout {
                    minimumInteritemSpacing = delegateFlowLayout.collectionView?(self, layout: self.collectionViewLayout, minimumInteritemSpacingForSectionAtIndex: 0) ?? 0.0
                } else if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
                    minimumInteritemSpacing = flowLayout.minimumInteritemSpacing
                }
                x += attribute.bounds.width - (minimumInteritemSpacing * 2)
                i++
            }
            setContentOffset(CGPoint(x: contentOffset.x - x, y: 0), animated: false)
            needsScrollToCenter = false
        }
        
    }
}

extension InfinityCollectionView {
    
    private func layoutRecenter() {
        let currentOffset = contentOffset
        let contentWidth = contentSize.width
        let centerOffsetX = contentWidth / 2.0
        
        let distanceFromCenterX = fabs(currentOffset.x - centerOffsetX)
        
        let allCellWidth = CGFloat(contentWidth / CGFloat(factor))
        if distanceFromCenterX > allCellWidth {
            let offset = CGFloat(fmodf(Float(currentOffset.x - centerOffsetX), Float(allCellWidth)))
            contentOffset = CGPoint(x: centerOffsetX + offset, y: currentOffset.y)
        }
    }
    
}