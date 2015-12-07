//
//  ViewController.swift
//  SampleLocalNotification
//
//  Created by kosuge on 2015/12/07.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var receiveBodyLabel: UILabel!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var btn: UIButton!

    @IBOutlet weak var constMainViewCenterY: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /// LocalNotificationの許可を取る
        LocalNotificationManager.registerNotification()
        setupView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerNotification()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

/// MARK : - public methods.
extension ViewController {
    
    func onTouchUpInsideBtn(btn: UIButton) {
        
        guard let text = bodyTextField.text where !text.isEmpty else {
            return
        }
        
        if bodyTextField.isFirstResponder() {
            bodyTextField.resignFirstResponder()
        }
        
        print("text = \(text)")
        bodyTextField.text = nil
        
        let alertBody = text
        let nowDate = NSDate()
        let fireDate = nowDate.dateByAddingTimeInterval(30)
        LocalNotificationManager.scheduleLocalNotificationAtDate(fireDate, alertBody: alertBody, userInfo: nil)
        
        let alertController = UIAlertController(title: nil, message: "LocalNotificationを30秒後に設定しました！", preferredStyle: .Alert)
        let action = UIAlertAction(title: "了解！", style: .Cancel, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func willShowKeyboardNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let aniDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        view.setNeedsLayout()
        view.setNeedsUpdateConstraints()
        constMainViewCenterY.constant = 60
        let animations: () -> Void = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        UIView.animateWithDuration(aniDuration, animations: animations)
    }
    
    func willHideKeyboardNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let aniDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        view.setNeedsLayout()
        view.setNeedsUpdateConstraints()
        constMainViewCenterY.constant = 0
        let animations: () -> Void = {[weak self] in
            self?.view.layoutIfNeeded()
        }
        UIView.animateWithDuration(aniDuration, animations: animations)
    }
    
    func tapViewGesture(gesture: UITapGestureRecognizer) {
        if bodyTextField.isFirstResponder() {
            bodyTextField.resignFirstResponder()
        }
    }
    
    func didOpenLocalNotification(notification: NSNotification) {
        guard let body = notification.userInfo?[LocalNotificationUserInfoBodyKey] as? String else {
            return
        }
        
        receiveBodyLabel.text = body
    }
    
}

/// MARK : - private methods.
extension ViewController {
    
    private func setupView() {
        btn.addTarget(self, action: "onTouchUpInsideBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        
        /// なんとなくボタンに装飾を...
        btn.layer.cornerRadius = 10.0
        btn.layer.borderWidth = 2.0
        btn.layer.borderColor = UIColor.blackColor().CGColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapViewGesture:")
        view.addGestureRecognizer(tapGesture)
    }
    
    private func registerNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willShowKeyboardNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willHideKeyboardNotification:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didOpenLocalNotification:", name: DidOpenFromLocalNotification, object: nil)
    }
    
    private func unregisterNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

