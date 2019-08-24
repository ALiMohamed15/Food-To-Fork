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
    let apiKey:String = "c34e5bd22e22eb9b4250014a38dbb85d"
    let RecepiesURL:String = "https://www.food2fork.com/api/get"
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    
    var imageURL = ""
    var recipeID = ""
    
    var prams : [String : String] = [:]
    var ingreds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       makeRequest()
    }
    
    
    // MARK : make request method
    func makeRequest(){
        
        prams = ["key" : apiKey , "rId" : recipeID ]
        getData(withURL: RecepiesURL, parameters: prams)
        
    }
    
    // MARK : Request Data From API Method
    func getData(withURL url:String , parameters : [String:String]) {
        
        Alamofire.request(url , method: .get , parameters : parameters).responseJSON { response in
            if response.result.isSuccess{
                
                print("Success!!")
                let json : JSON = JSON(response.result.value!)
                self.UpdateJSONdata(with: json)
                 print(json)
            }else{
                
                print("Request failed \(String(describing: response.result.error))")
            }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
