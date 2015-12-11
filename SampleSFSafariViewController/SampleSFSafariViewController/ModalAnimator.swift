//
//  ModalAnimator.swift
//  SampleSFSafariViewController
//
//  Created by kosuge on 2015/12/11.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

class ModalAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    var dismissing: Bool = false
    var percentageDriven: Bool = false
    
    private let scale: CGFloat = 0.95
    
    override init() {
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
                toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
                containerView = transitionContext.containerView() else {
            return
        }
        
        let toView = dismissing ? fromViewController.view : toViewController.view
        let fromView = dismissing ? toViewController.view : fromViewController.view
        let offset = containerView.frame.width
        
        containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        if dismissing {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }
        
        toView.frame = containerView.frame
        toView.transform = dismissing ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(offset, 0)
        fromView.frame = containerView.frame
        fromView.transform = dismissing ? CGAffineTransformMakeScale(scale, scale) : CGAffineTransformIdentity
        
        let aniDuration = transitionDuration(transitionContext)
        UIView.animateWithDuration(aniDuration, animations: {[weak self] () -> Void in
            if let weakSelf = self {
                toView.transform = weakSelf.dismissing ? CGAffineTransformMakeTranslation(offset, 0) : CGAffineTransformIdentity
                fromView.transform = weakSelf.dismissing ? CGAffineTransformIdentity : CGAffineTransformMakeScale(weakSelf.scale, weakSelf.scale)
            }
        }) { (finished) -> Void in
            toView.transform = CGAffineTransformIdentity
            fromView.transform = CGAffineTransformIdentity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
}
