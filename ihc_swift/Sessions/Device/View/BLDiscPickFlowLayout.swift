//
//  BLDiscPickFlowLayout.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/2/7.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import Foundation

class BLDiscPickFlowLayout: UICollectionViewFlowLayout {
    
    var scale = 1.0
    var scaleWidth = 110.0
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrs = super.layoutAttributesForElements(in: rect)
        
        let contentOffsetX = self.collectionView?.contentOffset.x
        let collectionViewCenterX = (self.collectionView?.frame.size.width)! * 0.5
        
        var newAttr = [UICollectionViewLayoutAttributes]()
        for attr in attrs! {
            var percent = fabs(Double(attr.center.x - contentOffsetX! - collectionViewCenterX)) / self.scaleWidth
            if percent > 1 {
                percent = 1
            }
            
            let lscale = 1 - (1 - self.scale) * percent
            attr.transform = CGAffineTransform.init(scaleX: CGFloat(lscale), y: CGFloat(lscale))
            newAttr.append(attr)
        }
        
        return newAttr
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
    }
    
    /**
     * 在collectionView滑动停止之后collectionView的偏移量
     */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        // 计算出最终显示的矩形框 遍历该矩形框中的cell相对中心线的间距选择最合适的cell进行调整
        var currentRect: CGRect = CGRect.init()
        currentRect.origin.x = proposedContentOffset.x
        currentRect.origin.y = 0
        currentRect.size = CGSize.init(width: (self.collectionView?.frame.size.width)!, height: (self.collectionView?.frame.size.height)!)
        
        // 获得对应rect中super已经计算好的布局属性
        let attrs = super.layoutAttributesForElements(in: currentRect)
        
        // 计算collectionView最中心点的x值
        let centerX = proposedContentOffset.x + (self.collectionView?.frame.size.width)! * 0.5
        
        // 存放最小的间距值
        var minDelta = MAXFLOAT
        for attr in attrs! {
            
            if abs(Int32(minDelta)) > abs(Int32(attr.center.x - centerX)) {
                minDelta = Float(attr.center.x - centerX)
            }
            
        }
        
        // 修改原有的偏移量
        let newOffset = CGPoint.init(x: proposedContentOffset.x + CGFloat(minDelta), y: proposedContentOffset.y)
        
        return newOffset;
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
