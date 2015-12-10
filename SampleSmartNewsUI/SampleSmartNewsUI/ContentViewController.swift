//
//  ContentViewController.swift
//  SampleSmartNewsUI
//
//  Created by kosuge on 2015/12/10.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

protocol ContentViewControllerDelegate: class {
    
    func didScrollOffset(offset: CGPoint, pageIndex: Int)
    func didSelectIndexPath(indexPath: NSIndexPath, item: String)
    func didEndDraggingOffset(offset: CGPoint, pageIndex: Int)
    
}

class ContentViewController: UIViewController {
    
    static func instantiateViewControllerAtIndex(index: Int) -> ContentViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        viewController.index = index
        return viewController
    }
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: ContentViewControllerDelegate? = nil
    
    private let maxCellCount = 100
    private(set) var index: Int = 0
    private var items: [String] = []
    
    private var _offset: CGPoint? = nil
    private var _inset: UIEdgeInsets? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        createItems()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let o = _offset {
            tableView.contentOffset = o
            _offset = nil
        }
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

/// MARK : - public methods.
extension ContentViewController {
    
    func setOffset(offset: CGPoint) {
        if let t = tableView {
            t.contentOffset = offset
        } else {
            _offset = offset
        }
    }
    
    func setInset(inset: UIEdgeInsets) {
        if let t = tableView {
            t.contentInset = inset
        } else {
            _inset = inset
        }
    }
}

extension ContentViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let string = items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = string
        return cell
    }
}

extension ContentViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.didScrollOffset(scrollView.contentOffset, pageIndex: index)
        let insetTop = _inset?.top ?? 0
        if scrollView.contentOffset.y < -insetTop {
            let inset = insetTop - (insetTop + scrollView.contentOffset.y)
            tableView.scrollIndicatorInsets.top = inset
        } else {
            tableView.scrollIndicatorInsets.top = insetTop
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.didEndDraggingOffset(scrollView.contentOffset, pageIndex: index)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        delegate?.didSelectIndexPath(indexPath, item: item)
    }
}

/// MARK: - private methods.
extension ContentViewController {
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        if let i = _inset {
            tableView.contentInset = i
            tableView.scrollIndicatorInsets = i
        }
        
        if let o = _offset {
            tableView.contentOffset = o
        }
    }
    
    private func createItems() {
        self.items = (0..<maxCellCount).map({ "cell \($0)"})
    }
    
}
