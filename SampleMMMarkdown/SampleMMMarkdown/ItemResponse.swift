//
//  Item.swift
//  SampleMMMarkdown
//
//  Created by kosuge on 2015/12/19.
//  Copyright © 2015年 RyoKosuge. All rights reserved.
//

import Foundation
import Himotoki

struct TagResponse: Decodable {
    let name: String
    let versions: [String]
    
    static func decode(e: Extractor) throws -> TagResponse.DecodedType {
        return try TagResponse(name: e <| "name", versions: e <|| "versions" )
    }
    
}

struct UserResponse: Decodable {
    
    let description: String?
    let facebookID: String?
    let followeesCount: Int
    let followersCount: Int
    let githubLoginName: String?
    let id: String
    let itemsCount: Int
    let linkedinID: String?
    let location: String?
    let name: String
    let organization: String?
    let permanentID: Int
    let profileImageURL: String
    let twitterScreenName: String?
    let websiteURL: String?
    
    static func decode(e: Extractor) throws -> UserResponse.DecodedType {
        return try UserResponse(description: e <|? "description", facebookID: e <|? "facebook_id", followeesCount: e <| "followees_count", followersCount: e <| "followers_count", githubLoginName: e <|? "github_login_name", id: e <| "id", itemsCount: e <| "items_count", linkedinID: e <|? "linkedin_id", location: e <|? "location", name: e <| "name", organization: e <|? "organization", permanentID: e <| "permanent_id", profileImageURL: e <| "profile_image_url", twitterScreenName: e <|? "twitter_screen_name", websiteURL: e <|? "website_url")
    }
    
}

struct ItemResponse: Decodable {
    
    let renderedBody: String
    let body: String
    let coediting: Bool
    let createdAt: String
    let id: String
    let privateItem: Bool
    let tags: [TagResponse]
    let title: String
    let updatedAt: String
    let URL: String
    let user: UserResponse
    
    static func decode(e: Extractor) throws -> ItemResponse.DecodedType {
        return try ItemResponse(renderedBody: e <| "rendered_body", body: e <| "body", coediting: e <| "coediting", createdAt: e <| "created_at", id: e <| "id", privateItem: e <| "private", tags: e <|| "tags", title: e <| "title", updatedAt: e <| "updated_at", URL: e <| "url", user: e <| "user")
    }
    
}
