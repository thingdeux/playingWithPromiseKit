//
//  RepoBrowserTableView.swift
//  PromisePractice
//
//  Created by Josh on 8/10/17.
//  Copyright © 2017 JoshLand. All rights reserved.
//

import UIKit

class RepoBrowserTableView: UITableView {
    
    fileprivate var bitbucketUsers = [BitbucketUser]()

    func setup(with repositories: [BitbucketUser]) {
        self.register(UINib(nibName: RepoBrowserTableViewCell.Constants.nibName, bundle: nil),
                      forCellReuseIdentifier: RepoBrowserTableViewCell.Constants.reuseId)
        self.bitbucketUsers = repositories
        
        DispatchQueue.main.async {
            self.reloadData()
        }
    }

}

extension RepoBrowserTableView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bitbucketUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension RepoBrowserTableView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.bitbucketUsers[indexPath.row]
        print(user.username)        
    }
}
