//
//  NavigationAnimator.swift
//  SampleSwipeNavigationController
//
//  Created by nagisa-kosuge on 2015/12/19.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

protocol NavigationAnimatorDelegate: class {
    
    func popViewController()
    func shouldBeginGesture(gesture: UIGestureRecognizer) -> Bool
    
}

class NavigationAnimator: UIPercentDrivenInteractiveTransition {
    
    private var isPop: Bool = false
    private var percentageDriven: Bool = false
    
    private let Scale: CGFloat = 0.95
    
    weak var delegate: NavigationAnimatorDelegate? = nil
    
    init(view: UIView) {
        super.init()
        setupView(view)
    }
    
}

/// MARK: - UIPanGestureReg
extension NavigationAnimator {
    
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }
        var percent = gesture.locationInView(view).x / view.bounds.width / 2.0
        percent = percent < 1 ? percent : 0.99
        percentageDriven = true
        switch gesture.state {
        case .Began:
            delegate?.popViewController()
        case .Changed:
            updateInteractiveTransition(percent)
        case .Ended, .Cancelled:
            gesture.velocityInView(view).x < 0 ? cancelInteractiveTransition() : finishInteractiveTransition()
            percentageDriven = false
        default:
            break
        }
    }
    
}

extension NavigationAnimator: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return delegate?.shouldBeginGesture(gestureRecognizer) ?? true
    }
    
}

/// MARK: - UINavigationControllerDelegate
extension NavigationAnimator: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPop = operation == UINavigationControllerOperation.Pop
        return self
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return percentageDriven ? self : nil
    }
    
}

/// MARK: UIViewControllerAnimatedTransitioning
extension NavigationAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            containerView = transitionContext.containerView() else {
                return
        }
        
        let toView = isPop ? fromViewController.view : toViewController.view
        let fromView = isPop ? toViewController.view : fromViewController.view
        let offset = containerView.frame.width
        
        containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        if isPop {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }
        
        toView.frame = containerView.frame
        toView.transform = isPop ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(offset, 0)
        fromView.frame = containerView.frame
        fromView.transform = isPop ? CGAffineTransformMakeScale(Scale, Scale) : CGAffineTransformIdentity
        
        let aniDuration = transitionDuration(transitionContext)
        UIView.animateWithDuration(aniDuration, animations: {[weak self] () -> Void in
            if let weakSelf = self {
                toView.transform = weakSelf.isPop ? CGAffineTransformMakeTranslation(offset, 0) : CGAffineTransformIdentity
                fromView.transform = weakSelf.isPop ? CGAffineTransformIdentity : CGAffineTransformMakeScale(weakSelf.Scale, weakSelf.Scale)
            }
            }) { (finished) -> Void in
                toView.transform = CGAffineTransformIdentity
                fromView.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
}

/// MARK: - private methods.
extension NavigationAnimator {
    
    private func setupView(view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
}