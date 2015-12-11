//
//  ViewController.swift
//  SampleSFSafariViewController
//
//  Created by kosuge on 2015/12/11.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

import BrightFutures
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let cellIdentifier = "Cell"
    private let aniDuration: NSTimeInterval = 0.2
    private let ItemCellHeight: CGFloat = 120
    
    private var items: [Item] = []
    private var isLoading: Bool = false
    private var animator = ModalAnimator()

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
        guard let URL = item.URL else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        showSafariViewWithURL(URL)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ItemCellHeight
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.dismissing = true
        return animator
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.dismissing = false
        return animator
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.animator.percentageDriven ? self.animator : nil
    }
    
}

extension ViewController {
    
    func handlePanGesture(gesture: UIScreenEdgePanGestureRecognizer) {
        var percent = gesture.locationInView(view).x / view.bounds.width / 2.0
        percent = percent < 1 ? percent : 0.99
        animator.percentageDriven = true
        switch gesture.state {
        case .Began:
            dismissViewControllerAnimated(true, completion: nil)
        case .Changed:
            animator.updateInteractiveTransition(percent)
        case .Ended, .Cancelled:
            gesture.velocityInView(view).x < 0 ? animator.cancelInteractiveTransition() : animator.finishInteractiveTransition()
            animator.percentageDriven = false
        default:
            break
        }
    }
    
}

extension ViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
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
        QiitaService.fetch().onFailure(Queue.main.context, callback: {[weak self] error in
            self?.showErrorAlert(error)
        }).onSuccess(Queue.main.context, callback: {[weak self] items in
            self?.items = items
            self?.tableView.reloadData()
            self?.hideActivity()
        })
    }
    
    private func showSafariViewWithURL(URL: NSURL) {
        let safariView = SafariViewController(URL: URL)
        safariView.delegate = self
        safariView.transitioningDelegate = self
        presentViewController(safariView, animated: true) {[weak self] () -> Void in
            if let weakSelf = self {
                let gesture = UIScreenEdgePanGestureRecognizer(target: weakSelf, action: "handlePanGesture:")
                gesture.edges = UIRectEdge.Left
                safariView.edgeView?.addGestureRecognizer(gesture)
            }
        }
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