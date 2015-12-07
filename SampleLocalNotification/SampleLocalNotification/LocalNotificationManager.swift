//
//  LocalNotificationManager.swift
//  SampleLocalNotification
//
//  Created by kosuge on 2015/12/07.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

/// LocalNotificationから起動したことを通知する
let DidOpenFromLocalNotification = "DidOpenFromLocalNotification"

/// userInfoの中のbodyを指すKey
let LocalNotificationUserInfoBodyKey = "body"

/// LocalNotification周りの処理を受け持つクラス
class LocalNotificationManager: NSObject {

    /// LocalNotificationを表示できるように登録処理をする
    static func registerNotification() {
        let application = UIApplication.sharedApplication()
        let settings = UIUserNotificationSettings(forTypes: [.Badge, .Alert, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    
    /// LocalNotificationを許諾してもらった時の処理
    /// - parameter settings:       許可してもらったTyep
    /// - parameter application:    UIApplication
    static func didRegisterUserNotificationSettings(settings: UIUserNotificationSettings, application: UIApplication) {
        let allowedType = settings.types
        switch allowedType {
        case UIUserNotificationType.None:
            print("許可されなかったよ")
        default:
            print("許可されたよ")
        }
    }
    
    /// LocalNotificationを設定する
    /// - parameter date:       表示する時間
    /// - parameter alertBody:      表示する文言
    /// - parameter userInfo:       Notificationに渡したい情報([NSObject: AnyObject])
    static func scheduleLocalNotificationAtDate(date: NSDate, alertBody: String, userInfo: [NSObject: AnyObject]?) {
        
        /// 今より過去に設定させない
        /// すぐに通知してしまうため
        if date.timeIntervalSinceNow <= 0 {
            return
        }
        
        /// LocalNotificationの作成
        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.timeZone = NSTimeZone.localTimeZone()
        localNotification.alertBody = alertBody
        localNotification.userInfo = userInfo
        localNotification.alertAction = "開く"
        
        /// 設定
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    /// LocalNotificationをキャンセルする
    static func cancelAllLocalNotifications() {
        guard let localNotifications = UIApplication.sharedApplication().scheduledLocalNotifications else {
            /// 設定されていないから何もしない
            return
        }
        
        for localNotification in localNotifications {
            /// userInfoの中にユニークな値(例えばIDとか)を入れておけば何のためのLocalNotificationなのか判別がつく
            if let userInfo = localNotification.userInfo {
                /// あとはよしなに...
                print("userInfo = \(userInfo)")
            }
        }
        
        /// 全てを削除する
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    /// LocalNotificationから開かれた場合の処理
    /// - parameter localNotification:      受け取ったLocalNotification
    /// - parameter application:            UIApplication
    static func didReceiveLocalNotification(localNotification: UILocalNotification, application: UIApplication) {
        print("受け取ったよ")
        notifyReceivedLocalNotification(localNotification)
    }
    
    /// アプリが起動した時にLocalNotificationから開かれたどうかを確認する
    /// LocalNotificationから開かれた場合は処理をする
    /// - parameter launchOptions:   起動時の値
    /// - parameter application:        UIApplication
    static func didFinishedLaunchingOptions(launchOptions: [NSObject: AnyObject]?, application: UIApplication) {
        
        /// LocalNotificationから開かれた場合launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]にUILocalNotificationが代入されている
        guard let localNotification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification else {
            /// LocalNotificationから開かれてないので何もしない
            return
        }
        
        notifyReceivedLocalNotification(localNotification)
    }
    
}

/// MARK : - private methods

extension LocalNotificationManager {
    
    /// LocalNotificationを受け取ったことを通知する
    /// - parameter localNotification:      受け取ったLocalNotification
    private static func notifyReceivedLocalNotification(localNotification: UILocalNotification) {
        guard let body = localNotification.alertBody else {
            return
        }
        
        let userInfo = [LocalNotificationUserInfoBodyKey: body]
        let notification = NSNotification(name: DidOpenFromLocalNotification, object: nil, userInfo: userInfo)
        let queue = NSNotificationQueue.defaultQueue()
        queue.enqueueNotification(notification, postingStyle: NSPostingStyle.PostWhenIdle)
    }
    
}
