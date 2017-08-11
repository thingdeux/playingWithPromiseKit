//
//  RepoBrowserTableViewCell.swift
//  PromisePractice
//
//  Created by Josh on 8/10/17.
//  Copyright © 2017 JoshLand. All rights reserved.
//

import UIKit

class RepoBrowserTableViewCell: UITableViewCell {
    
    enum Constants {
        static var nibName = "RepoBrowserTableViewCell"
        static var reuseId = "RepoBrowserTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }
    
}
