//
//  DetailViewController.swift
//  SampleMMMarkdown
//
//  Created by kosuge on 2015/12/19.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit
import MMMarkdown

class DetailViewController: UIViewController {
    
    static func instantiateViewControllerWithItem(item: ItemResponse) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        viewController.item = item
        return viewController
    }
    
    @IBOutlet weak var textView: UITextView!
    private var item: ItemResponse!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

/// MARK: - private methods.
extension DetailViewController {
    
    private func setupView() {
        if let htmlString = try? MMMarkdown.HTMLStringWithMarkdown(item.body) {
            let style = "<style>img { max-width: 300px; height: auto; }</style>\n"
            let body = style + htmlString
            print(body)
            if let data = body.dataUsingEncoding(NSUnicodeStringEncoding) {
                let attribute = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                if let attributeText = try? NSAttributedString(data: data, options: attribute, documentAttributes: nil) {
                    textView.attributedText = attributeText
                }
            }
        }
        textView.editable = false
    }
    
}
