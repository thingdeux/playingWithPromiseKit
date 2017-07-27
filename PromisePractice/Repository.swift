//
//  Repository.swift
//  PromisePractice
//
//  Created by Josh on 7/26/17.
//  Copyright © 2017 JoshLand. All rights reserved.
//

//https://api.bitbucket.org/2.0/repositories/

import SwiftyJSON
import Alamofire
import PromiseKit

enum BitbucketType {
    case user
    case repository
}

struct Repository {
    var uuid: String?
    var name: String?
    var owner: BitbucketUser?
    var description: String?
    var type: BitbucketType = .repository
    
    static func buildRepository(from json: JSON) -> Repository? {
        return Repository(uuid: json["uuid"].string,
                          name: json["name"].string,
                          owner: BitbucketUser.buildBitBucketUser(from: json["owner"]),
                          description: json["description"].string, type: .repository)
    }
}


struct BitbucketUser {
    var username: String?
    var uuid: String?
    var displayName: String?   // display_name
    var links: BitbucketLinks?
    var type: BitbucketType = .user
    
    static func buildBitBucketUser(from userDataJson: JSON) -> BitbucketUser? {
        return BitbucketUser(username: userDataJson["username"].string,
                             uuid: userDataJson["uuid"].string,
                             displayName: userDataJson["display_name"].string,
                             links: BitbucketLinks.buildBitbucketLinks(from: userDataJson["links"]),
                             type: .user)
    }
}


struct BitbucketLinks {
    var selfUrl: String?
    var htmlUrl: String?
    var avatarUrl: String?
    
    static func buildBitbucketLinks(from json: JSON) -> BitbucketLinks? {
        return BitbucketLinks(selfUrl: json["self"].string, htmlUrl: json["html"].string, avatarUrl: json["avatar"].string)
    }
}

struct BitbucketError : Error {
}

