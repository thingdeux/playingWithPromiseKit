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
    private(set) var uuid: String?
    private(set) var name: String?
    private(set) var owner: BitbucketUser?
    private(set) var description: String?
    private(set) var type: BitbucketType = .repository
    
    static func buildRepository(from json: JSON) -> Repository? {
        return Repository(uuid: json["uuid"].string,
                          name: json["name"].string,
                          owner: BitbucketUser.buildBitBucketUser(from: json["owner"]),
                          description: json["description"].string, type: .repository)
    }
}


struct BitbucketUser {
    private(set) var username: String?
    private(set) var uuid: String?
    private(set) var displayName: String?   // display_name
    private(set) var links: BitbucketLinks?
    private(set) var type: BitbucketType = .user
    private(set) var repositories: [Repository]
    
    static func buildBitBucketUser(from userDataJson: JSON) -> BitbucketUser {
        return BitbucketUser(username: userDataJson["username"].string,
                             uuid: userDataJson["uuid"].string,
                             displayName: userDataJson["display_name"].string,
                             links: BitbucketLinks.buildBitbucketLinks(from: userDataJson["links"]),
                             type: .user,
                             repositories: [Repository]()
                )
    }
    
    mutating func setRepositories(_ repos: [Repository]) {
        self.repositories = repos
    }
}


struct BitbucketLinks {
    private(set) var selfUrl: String?
    private(set) var htmlUrl: String?
    private(set) var avatarUrl: String?
    private(set) var hooksUrl: String?
    private(set) var repositoriesUrl: String?
    private(set) var followersUrl: String?
    private(set) var followingUrl: String?
    private(set) var snippetsUrl: String?
    
    static func buildBitbucketLinks(from json: JSON) -> BitbucketLinks? {
        return BitbucketLinks(selfUrl: json["self"]["href"].string,
                              htmlUrl: json["html"]["href"].string,
                              avatarUrl: json["avatar"]["href"].string,
                              hooksUrl: json["hooks"]["href"].string,
                              repositoriesUrl: json["repositories"]["href"].string,
                              followersUrl: json["followers"]["href"].string,
                              followingUrl: json["following"]["href"].string,
                              snippetsUrl: json["snippets"]["href"].string)
        }
}


enum BitbucketAPIError {
    case notFound
    case timedOut
    case unknown
    case missingUrl
    case malformedData
}

struct BitbucketError : Error {
    var error: BitbucketAPIError
    init(_ error: BitbucketAPIError = .unknown) {
        self.error = error
    }
}

