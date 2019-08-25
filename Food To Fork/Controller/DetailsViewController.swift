//
//  DetailsViewController.swift
//  Food To Fork
//
//  Created by IOS System on 8/23/19.
//  Copyright © 2019 IOS Systems. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class DetailsViewController: UIViewController {
   
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var shouldSave = false
    
    var imageURL = ""
    var recipeID = ""
    
    var prams : [String : String] = [:]
    var ingreds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellHeightForRow()
        stylingMethode()
        makeRequest()
        
    }
    
    
    // MARK : make request method
    func makeRequest(){
        
        prams = ["key" : Requests.Key , "rId" : recipeID ]
        Requests.sharedInstance.getData(withURL: Requests.GetUrl, parameters: prams) { (JSON) in
            self.UpdateJSONdata(with: JSON)
        }
    }
    
    // MARK: JSON Data Method
    func UpdateJSONdata(with json:JSON) {
        
        rank.text = json["recipe"]["social_rank"].stringValue
        let ingredes = json["recipe"]["ingredients"].arrayValue
        recipeTitle.text = json["recipe"]["title"].stringValue
        imageURL = json["recipe"]["image_url"].stringValue
        
        for i in ingredes.indices {
            ingreds.append(ingredes[i].stringValue)
        }
        
        loadImage()
        tableview.reloadData()
    }
    
    //MARK : load Image from URL method
    func loadImage(){
        
        recipeImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "Food Icon"))
    }
    
    func stylingMethode() {
        
        recipeImage.layer.cornerRadius = 7
        rank.layer.cornerRadius = 7
        
        
    }
   
    
    @IBAction func Save(_ sender: UIButton) {
        
        if shouldSave == false {
            saveButton.setImage(UIImage(named: "Bookmarked"), for: .normal)
            shouldSave = true
        }else {
            saveButton.setImage(UIImage(named: "Bookmark"), for: .normal)
            shouldSave = false
        }
        print("saved")
    }
    
}



//MARK : Set up tableview methodes

extension DetailsViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingreds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = ingreds[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func cellHeightForRow() {
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 60
    }
}
