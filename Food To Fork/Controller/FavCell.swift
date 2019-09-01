//
//  FavCell.swift
//  Food To Fork
//
//  Created by IOS System on 8/31/19.
//  Copyright © 2019 IOS Systems. All rights reserved.
//

import UIKit

class FavCell: UITableViewCell {
    
 
    @IBOutlet weak var Pic: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
