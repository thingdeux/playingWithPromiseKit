//
//  RepoBrowserTableViewCell.swift
//  PromisePractice
//
//  Created by Josh on 8/10/17.
//  Copyright © 2017 JoshLand. All rights reserved.
//

import UIKit

class RepoBrowserTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expandContractButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    private var currentUser: BitbucketUser?
    
    private var repositoryCountText: String {
        get {
            guard let user = self.currentUser else { return "No Repositories" }
            switch user.repositories.count {
            case 0:
                return "No Repositories!"
            case 1:
                return "1 Repository"
            default:
                return "\(user.repositories.count) Repositories"
            }
        }
    }
    
    enum Constants {
        static var nibName = "RepoBrowserTableViewCell"
        static var reuseId = "RepoBrowserTableViewCell"
    }
    
    func setup(with user: BitbucketUser) {
        DispatchQueue.main.async {
            self.currentUser = user
            self.titleLabel.text = user.displayName ?? "Unknown?!?"
            self.subtitleLabel.text = self.repositoryCountText
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text = ""
        self.subtitleLabel.text = ""
    }
    
    override func prepareForReuse() {
        DispatchQueue.main.async {
            self.titleLabel.text = ""
            self.subtitleLabel.text = ""
            self.expandContractButton.imageView?.image = #imageLiteral(resourceName: "DownChevron")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }
    
    @IBAction func expandContractReleased(_ sender: Any) {        
    }
    
    @IBAction func expandContractTouched(_ sender: Any) {
        print("EXPAND")
    }
}
