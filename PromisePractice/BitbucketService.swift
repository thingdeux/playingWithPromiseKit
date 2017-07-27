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
                Alamofire.request("\(path)", method: type).responseJSON { response in
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
                    reject(BitbucketError(.malformedData))
                }
            }.catch { error in
                reject(BitbucketError(.unknown))
            }
        }
    }
    
    /// Get List of a users repositories
    func getRepositories(for user: BitbucketUser) -> Promise<[Repository]> {
        return Promise { fulfill, reject in
            firstly {
                self.expandUserDetails(for: user)
            }.then(on: self.apiQueue) { user -> (Promise<JSON>) in
                if let repositoriesUrl = user.links?.repositoriesUrl {
                    return self.queueAPICall(uri: repositoriesUrl, type: .get)
                } else {
                    throw (BitbucketError(.missingUrl))
                }
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
                    reject(BitbucketError(.malformedData))
                }
            }.catch { error in
                reject(error)
            }
            
        }
    }
    
}

// MARK: Bitbucket USER API Methods
extension BitbucketAPIService {
    /// Get Bitbucket User Detail response and fully populate BitbucketUser Model
    fileprivate func expandUserDetails(for user: BitbucketUser) -> Promise<BitbucketUser> {
        return Promise { fulfill, reject in
            guard let profileUrl = user.links?.selfUrl else {
                reject(BitbucketError(.missingUrl))
                return
            }
            firstly {
                self.queueAPICall(uri: profileUrl, type: .get)
                }.then(on: self.apiQueue) { json -> () in
                    fulfill(BitbucketUser.buildBitBucketUser(from: json))
                }.catch { error in
                    reject(error)
            }
            
        }
    }
}
