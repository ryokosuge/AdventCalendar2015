//
//  QiitaService.swift
//  SampleSFSafariViewController
//
//  Created by kosuge on 2015/12/11.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit

import SwiftyJSON
import BrightFutures
import Alamofire

/// QiitaからItem一覧を取得するクラス
class QiitaService: NSObject {
    
    /// QiitaからItem一覧へGETリクエストを取得してItemクラスに変換して返す
    static func fetch() -> Future<[Item], NSError> {
        let promise = Promise<[Item], NSError>()
        
        Queue.global.async {
            let path = "https://qiita.com/api/v2/items?page=1&per_page=20"
            request(.GET, path).validate().responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) -> Void in
                switch response.result {
                case .Success(let value):
                    let items = JSON(value).arrayValue.map({ Item(json: $0) })
                    promise.success(items)
                case .Failure(let error):
                    promise.failure(error)
                }
            })
        }
        
        return promise.future
    }

}
