//
//  ItemTableViewCell.swift
//  SampleSFSafariViewController
//
//  Created by kosuge on 2015/12/11.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

import SwiftyJSON

/// ItemTableViewCellを表示する上で必要な要素を保持するクラス
class Item {
    
    /// 記事のタイトル
    let title: String?
    
    /// 記事のコンテンツ
    let body: String?
    
    /// 記事のURL
    let URL: NSURL?
    
    init(json: JSON) {
        self.title = json["title"].string
        self.body = json["body"].string
        self.URL = NSURL(string: json["url"].stringValue)
    }
    
}

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
    
    func setItem(item: Item) {
        titleLabel.text = item.title
        bodyLabel.text = item.body
    }
    
}
