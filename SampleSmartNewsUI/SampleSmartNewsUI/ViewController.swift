//
//  ViewController.swift
//  SampleSmartNewsUI
//
//  Created by kosuge on 2015/12/10.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var progressTextLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var constProgressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constMenuViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var constProgressBarViewWidth: NSLayoutConstraint!
    
    private var pageViewController: UIPageViewController? = nil
    
    private let MaxPage: Int = 10
    private let MaxContentInset = UIEdgeInsets(top: 88, left: 0, bottom: 0, right: 0)
    private let DefaultProgressViewHeight: CGFloat = 64.0
    private let PulledDownTextInterval: CGFloat = -70.0
    private let ReleasedTextInterval: CGFloat = -120.0
    
    private var currentIndex: Int = 0
    private var isLoading: Bool = false {
        didSet {
            progressTextLabel.text = isLoading ? "更新中" : "Sample"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

/// MARK: - PageViewController Delegate.
extension ViewController: ContentViewControllerDelegate {
    
    func didScrollOffset(offset: CGPoint, pageIndex: Int) {
        let offsetY = offset.y + MaxContentInset.top
        let barHeight = navigationBar.frame.height
        if offsetY < barHeight {
            if offsetY <= 0 {
                let progressViewHeight = DefaultProgressViewHeight - offsetY
                constProgressViewHeight.constant = progressViewHeight
                constMenuViewTopMargin.constant = 0
            } else {
                constMenuViewTopMargin.constant = -offsetY
                constProgressViewHeight.constant = DefaultProgressViewHeight
            }
        } else {
            constMenuViewTopMargin.constant = -navigationBar.frame.height
        }
        
        if !isLoading {
            if offsetY < ReleasedTextInterval {
                progressTextLabel.text = "はなして更新"
            } else if offsetY < PulledDownTextInterval {
                progressTextLabel.text = "引き下げて更新"
            } else {
                progressTextLabel.text = "Sample"
            }
        }
    }
    
    func didSelectIndexPath(indexPath: NSIndexPath, item: String) {
        performSegueWithIdentifier("ShowDetail", sender: nil)
    }
    
    func didEndDraggingOffset(offset: CGPoint, pageIndex: Int) {
        if !isLoading {
            let offsetY = offset.y + MaxContentInset.top
            if offsetY < ReleasedTextInterval {
                fetch()
            }
        }
    }
}

/// MARK: - UIContentViewController Delegate.
extension ViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewController = pageViewController.viewControllers?.first as? ContentViewController {
            currentIndex = viewController.index
        }
    }
    
}


/// MARK: - UIPageViewController DataSource
extension ViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let beforeIndex = currentIndex - 1
        return viewControllerAtIndex(beforeIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let afterIndex = currentIndex + 1
        return viewControllerAtIndex(afterIndex)
    }
    
}

/// MARK: - private methods.
extension ViewController {
    
    private func fetch() {
        isLoading = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {[weak self] () -> Void in
            var progress: CGFloat = 0.0
            while (progress < 100.0) {
                let rand = CGFloat(Int(arc4random_uniform(10)))
                progress += rand
                dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                    self?.updateProgressBarPercentage((progress / 100.0))
                })
                NSThread.sleepForTimeInterval(0.05)
            }
            dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                self?.updateProgressBarPercentage(progress)
            })
            
            dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                self?.finihed()
            })
            
        }
    }
    
    private func finihed() {
        isLoading = false
        UIView.animateWithDuration(0.3, animations: {[weak self] () -> Void in
            self?.progressBarView.alpha = 0.0
        }) {[weak self] (finished) -> Void in
            self?.constProgressBarViewWidth.constant = 0
            self?.progressBarView.alpha = 1.0
        }
    }
    
    private func updateProgressBarPercentage(percentage: CGFloat) {
        let progress = progressView.frame.width * percentage
        constProgressBarViewWidth.constant = progress
    }
    
    /// Viewに関することを処理する
    private func setupView() {
        /// navigationControllerのnavigationBarは非表示にする
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        /// 自前のnavigationBarの設定
        navigationBar.translucent = true
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()
        
        let pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageViewController.willMoveToParentViewController(self)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.frame = containerView.bounds
        pageViewController.view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        containerView.addSubview(pageViewController.view)
        addChildViewController(pageViewController)
        pageViewController.didMoveToParentViewController(self)
        self.pageViewController = pageViewController
        
        if let viewController = viewControllerAtIndex(currentIndex) {
            pageViewController.setViewControllers([viewController], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    private func viewControllerAtIndex(index: Int) -> ContentViewController? {
        
        if index < 0 || MaxPage < index {
            return nil
        }
        
        let viewController = ContentViewController.instantiateViewControllerAtIndex(index)
        viewController.delegate = self
        viewController.setInset(MaxContentInset)
        viewController.setOffset(CGPoint(x: 0, y: -MaxContentInset.top))
        
        return viewController
    }
}

