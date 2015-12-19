//
//  ViewController.swift
//  SampleMMMarkdown
//
//  Created by kosuge on 2015/12/19.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit
import BrightFutures

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let cellIdentifier = "Cell"
    private let aniDuration: NSTimeInterval = 0.2
    private let ItemCellHeight: CGFloat = 120
    
    private var items: [ItemResponse] = []
    private var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
        setupItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ItemTableViewCell
        let item = items[indexPath.row]
        cell.setItem(item)
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        let viewController = DetailViewController.instantiateViewControllerWithItem(item)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ItemCellHeight
    }
}

extension ViewController {
    
    private func showActivity() {
        activityIndicator.alpha = 0
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        UIView.animateWithDuration(aniDuration) {[weak self] () -> Void in
            self?.activityIndicator.alpha = 1
        }
    }
    
    private func hideActivity() {
        UIView.animateWithDuration(aniDuration, animations: {[weak self] () -> Void in
            self?.activityIndicator.alpha = 0
        }) {[weak self] (finished) -> Void in
            self?.activityIndicator.hidden = true
        }
    }
    
    private func setupItem() {
        showActivity()
        QiitaAPI.fetchItems().onSuccess(Queue.main.context, callback: {[weak self] response in
            self?.items = response
            self?.tableView.reloadData()
            self?.hideActivity()
        })
    }
    
    private func showErrorAlert(error: NSError) {
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let itemNib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        tableView.registerNib(itemNib, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
        
        activityIndicator.hidden = true
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = false
    }
    
}
