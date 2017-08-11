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
    @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!
    @IBOutlet weak var repositoryTableView: RepoBrowserTableView!
    
    fileprivate var bitbucketUsers = [String: BitbucketUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstly {
            BitbucketAPIService.shared.getLatestRepos()
        }.then { repositories in
            self.expandAllRepositories(repositories)
        }.then { finished -> () in
            self.repositoryTableView.setup(with: self.bitbucketUsers.map { return $0.value })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { 
                self.setLoading(to: false)
            })
        }.catch { _ in
            // TODO: Set error state
            print("UH OH - Failure")
        }
    }
    
    /// Take each of the users that were found in the latest repos call and get their respective repos.
    private func expandAllRepositories(_ repositories: [Repository]) -> Promise<Bool> {
        return Promise { fulfill, reject in
            let repoAcquisitionPromises = repositories.map { (repository) -> Promise<BitbucketUser> in
                guard let user = repository.owner, let username = user.username else {
                    return Promise<BitbucketUser>(error: BitbucketError(.malformedData))
                }
                return self.setRepositories(for: user, username: username, repository: repository)
            }
            
            // Queue up multiple promises for expanding and setting users' repositories
            when(resolved: repoAcquisitionPromises).then { (results: [Result<BitbucketUser>]) -> () in
                // All expansion is complete - fulfull promise
                fulfill(true)
            }.catch(execute: { (error) in
                print(error)
            })
        }
    }
    
    /// Hit Bitbucket API and get detail information for the users repositories.
    private func setRepositories(for user: BitbucketUser, username: String, repository: Repository) -> Promise<BitbucketUser> {
        return Promise { fulfill, reject in
            firstly {
                BitbucketAPIService.shared.getRepositories(for: user)
                }.then(on: DispatchQueue.global()) { repositories -> () in
                    var updatedUser = user
                    updatedUser.setRepositories(repositories)
                    self.bitbucketUsers[username] = updatedUser
                    fulfill(updatedUser)
                }.catch { error in
                    print(error)
            }
        }
    }
}

// MARK: UI Helpers
extension RepoBrowserViewController {
    fileprivate func setLoading(to shouldLoad: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: { 
                if shouldLoad {
                    self.loadingActivityView.alpha = 1
                } else {
                    self.loadingActivityView.alpha = 0
                }
            })
        }
    }
}
