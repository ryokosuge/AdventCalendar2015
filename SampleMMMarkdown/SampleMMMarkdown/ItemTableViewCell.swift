//
//  ItemTableViewCell.swift
//  SampleSFSafariViewController
//
//  Created by kosuge on 2015/12/11.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

/// QiitaのItemを表示するTableViewCell
class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setItem(item: ItemResponse) {
        titleLabel.text = item.title
        bodyLabel.text = item.body
    }
    
}
