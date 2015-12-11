//
//  SafariViewController.swift
//  SampleSFSafariViewController
//
//  Created by kosuge on 2015/12/11.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: SFSafariViewController {
    
    private var _edgeView: UIView?
    var edgeView: UIView? {
        if _edgeView == nil && isViewLoaded() {
            let edgeView = UIView()
            edgeView.translatesAutoresizingMaskIntoConstraints = false
            edgeView.backgroundColor = UIColor(white: 1.0, alpha: 0.005)
            view.addSubview(edgeView)
            let widthConstraint = NSLayoutConstraint(item: edgeView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 5)
            edgeView.addConstraint(widthConstraint)
            let leadingConstraint = NSLayoutConstraint(item: edgeView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
            let topConstraint = NSLayoutConstraint(item: edgeView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: edgeView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            view.addConstraint(leadingConstraint)
            view.addConstraint(topConstraint)
            view.addConstraint(bottomConstraint)
            _edgeView = view
        }
        
        return _edgeView
    }

}
