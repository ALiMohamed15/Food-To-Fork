//
//  TableViewCell.swift
//  Food To Fork
//
//  Created by IOS System on 8/24/19.
//  Copyright © 2019 IOS Systems. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var Puplisher: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Rate: UILabel!
    @IBOutlet weak var rImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likePressed(_ sender: UIButton) {
        
    }
    
    
    
}
