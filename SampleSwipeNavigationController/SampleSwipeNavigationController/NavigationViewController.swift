//
//  NavigationViewController.swift
//  SampleSwipeNavigationController
//
//  Created by nagisa-kosuge on 2015/12/19.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
    
    var animator: NavigationAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        animator = NavigationAnimator(view: self.view)
        animator.delegate = self
        delegate = animator
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NavigationViewController: NavigationAnimatorDelegate {
    
    func popViewController() {
        popViewControllerAnimated(true)
    }
    
    func shouldBeginGesture(gesture: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
}
