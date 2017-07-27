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
    fileprivate let apiQueue = DispatchQueue(label: "BitbucketAPIQueue", qos: .userInitiated, attributes: .concurrent)
    
    private init() {
    }
    
    fileprivate func queueAPICall(uri path: String, type: HTTPMethod) -> Promise<JSON> {
        return Promise { fulfill, reject in
            self.apiQueue.async { [weak self] in
                guard let `self` = self else { return }
                Alamofire.request("\(self.baseAPIUri)\(path)", method: type).responseJSON { response in
                    if let responseValue = response.result.value {
                        fulfill(JSON(responseValue))
                    } else {
                        reject(response.error ?? BitbucketError())
                    }
                }
            }
        }
    }
    
}

// MARK: Bitbucket REPOSITORY API Methods
extension BitbucketAPIService {
    /// Get List of latest Bitbucket Repositories
    func getLatestRepos() -> Promise<[Repository]> {
        return Promise { fulfill, reject in
            firstly {
                self.queueAPICall(uri: "\(self.baseAPIUri)/repositories/?pagelen=4", type: .get)
            }.then(on: self.apiQueue) { json -> () in
                if let repositoryArray = json["values"].array {
                    var repositories = [Repository]()
                    for repositoryAsJson in repositoryArray {
                        if let repository = Repository.buildRepository(from: repositoryAsJson) {
                            repositories.append(repository)
                        }
                    }
                    fulfill(repositories)
                } else {
                    reject(BitbucketError())
                }
            }.catch { error in
                reject(BitbucketError())
            }
        }
    }
    
    func getRepositories(for user: BitbucketUser){
        
    }
}
