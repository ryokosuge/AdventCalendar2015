//
//  QiitaAPI.swift
//  SampleMMMarkdown
//
//  Created by kosuge on 2015/12/19.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import UIKit
import BrightFutures
import Alamofire
import Himotoki

class QiitaAPI {
    
    static func fetchItems() -> Future<[ItemResponse], NSError> {
        let promise = Promise<[ItemResponse], NSError>()
        Queue.global.async {
            let path = "https://qiita.com/api/v2/users/ryokosuge/items"
            let parameters: [String: AnyObject] = ["page": 1, "per_page": 20]
            Alamofire.request(.GET, path, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil)
                .validate().responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) -> Void in
                    switch response.result {
                    case .Failure(let error):
                        promise.failure(error)
                    case .Success(let value):
                        if let values = value as? [AnyObject], items: [ItemResponse] = try? values.map({ try decode($0) }) {
                            promise.success(items)
                        }
                    }
            })
        }
        
        return promise.future
    }

}
