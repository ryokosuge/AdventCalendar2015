//
//  CollectionViewCell.swift
//  SampleInfinityCollectionView
//
//  Created by kosuge on 2015/12/10.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setIndex(index: Int) {
        label.text = "\(index)"
    }
    
}
