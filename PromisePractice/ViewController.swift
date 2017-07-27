//
//  ViewController.swift
//  PromisePractice
//
//  Created by Josh on 7/26/17.
//  Copyright © 2017 JoshLand. All rights reserved.
//

import UIKit
import PromiseKit


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstly {
            BitbucketAPIService.shared.getLatestRepos()
        }.then { repositories in
            self.populateRepositories(repositories)
        }.then { repositories in
            break
        }.catch { _ in }
        
    }
    
    private func populateRepositories(_ repos: [Repository]) -> Promise<[Repository]> {
        for repo in repos {
            print("Found Repo: \(repo.name ?? "Nothin'") - ",
                  "Owner(\(repo.owner?.displayName ?? repo.owner?.username ?? "??"))")
        }
        return Promise {fulfill, _ in
            fulfill(repos)
        }
    }

}

