//
//  BitbucketService.swift
//  PromisePractice
//
//  Created by Josh on 7/26/17.
//  Copyright © 2017 JoshLand. All rights reserved.
//

import UIKit

import SwiftyJSON
import Alamofire
import PromiseKit


class BitbucketAPIService {
    static let shared = BitbucketAPIService()
    fileprivate let baseAPIUri = "https://api.bitbucket.org/2.0"
    
    private init() {
        
    }
    
}

// MARK: Bitbucket REPOSITORY API Methods

/// Get List of latest Bitbucket Repositories
extension BitbucketAPIService {
    func getLatestRepos() -> Promise<[Repository]> {
        return Promise { fulfill, reject in
            Alamofire.request("\(self.baseAPIUri)/repositories/?pagelen=4", method: .get).responseJSON { response in
                if let responseValue = response.result.value {
                    let json = JSON(responseValue)
                    
                    if let repositoryArray = json["values"].array {
                        var repositories = [Repository]()
                        for repositoryAsJson in repositoryArray {
                            if let repository = Repository.buildRepository(from: repositoryAsJson) {
                                repositories.append(repository)
                            }
                        }
                        fulfill(repositories)
                    } else {
                        reject(response.error ?? BitbucketError())
                    }
                }
            }
        }
        
    }
}


