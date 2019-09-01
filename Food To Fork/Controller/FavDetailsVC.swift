//
//  FavDetailsVC.swift
//  Food To Fork
//
//  Created by IOS System on 9/1/19.
//  Copyright © 2019 IOS Systems. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class FavDetailsVC: UIViewController {
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var ingredTableview: UITableView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var ranlkLBL: UILabel!
    
    var ttitle = ""
    var rank = ""
    var image = ""
    var ingreds = List<String>()
    var ingredsArray = [String]()
    
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        stylingUI()
    }
    
    func updateUI() {
        Image.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "Food Icon"))
        ranlkLBL.text = rank
        titleLBL.text = ttitle
    }

    func stylingUI(){
        
        Image.layer.cornerRadius = 7
        ranlkLBL.layer.cornerRadius = 7
        
        ingredTableview.rowHeight = UITableView.automaticDimension
        ingredTableview.estimatedRowHeight = 60
        
    }
    
}


extension FavDetailsVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavDetailsCell", for: indexPath)
      
        cell.textLabel?.text = ingredsArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    
    
    
    
}
