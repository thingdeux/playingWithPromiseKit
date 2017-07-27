//
//  RepoBrowserViewController.swift
//  PromisePractice
//
//  Created by Josh on 7/27/17.
//  Copyright © 2017 JoshLand. All rights reserved.
//

import UIKit
import PromiseKit

class RepoBrowserViewController: UIViewController {
    private var bitbucketUsers = [String: BitbucketUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstly {
            BitbucketAPIService.shared.getLatestRepos()
        }.then { repositories in
            self.expandAllRepositories(repositories)
        }.then { finished -> () in
            
        }.catch { _ in }
    }
    
    
    
    
    /// Take each of the users that were found in the latest repos call and get their repos.
    private func expandAllRepositories(_ repositories: [Repository]) -> Promise<Bool> {
        return Promise { fulfill, reject in
            for repository in repositories {
                if let user = repository.owner {
                    firstly {
                        BitbucketAPIService.shared.getRepositories(for: user)
                    }.then { repositories -> () in
                        if let username = user.username {
                            var updatedUser = user
                            updatedUser.setRepositories(repositories)
                            self.bitbucketUsers[username] = updatedUser
                        }
                    // TODO: JJ - I want a 'when' here or a level above actually that calls the Bool (Succeeeded) promise
                    // Only after I've finished expanding all of the bitbucket users.
                    }.catch { error in
                            
                    }
                }
            }
        }
    }

}
