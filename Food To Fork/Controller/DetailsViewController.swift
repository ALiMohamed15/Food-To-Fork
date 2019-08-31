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
import RealmSwift

class DetailsViewController: UIViewController {
   
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var shouldSave = false
    
    var recipeID = ""
    
    var prams : [String : String] = [:]
    
    
    
    var ingreds = [String]()
    var recTitle = ""
    var recRank = ""
    var imageURL = ""
    
    
    let realm = try! Realm()
    
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
        
        recRank = json["recipe"]["social_rank"].stringValue
        recTitle = json["recipe"]["title"].stringValue
        imageURL = json["recipe"]["image_url"].stringValue
        let ingredes = json["recipe"]["ingredients"].arrayValue
        
        for i in ingredes.indices {
            ingreds.append(ingredes[i].stringValue)
        }
        updateUI()
        tableview.reloadData()
    }
    
    //MARK : Upted UI Method
    func updateUI() {
        
        rank.text = recRank
        recipeTitle.text = recTitle
        recipeImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "Food Icon"))
    }
    
    //    MARK: Save button pressed 
    @IBAction func Save(_ sender: UIButton) {
        
        let saveRecipe = Recipe()
        new(recipe: saveRecipe)
        
        if shouldSave == false {
            saveButton.setImage(UIImage(named: "Bookmarked"), for: .normal)
            shouldSave = true
            save(recipe : saveRecipe)
            print("SAVED!")
            print(saveRecipe.title)
            saveButton.isEnabled = false
        }
    }
    
    //    MARK: adding recipe properties
    func new(recipe : Recipe){
        
        recipe.rank = recRank
        recipe.title = recTitle
        recipe.image = imageURL
       
        for i in ingreds.indices {
            recipe.ingerdients.append(ingreds[i])
        }
    }
    
    //    MARK: saving to realm
    func save(recipe : Recipe) {
        do {
            try realm.write {
                realm.add(recipe)
            }
        } catch {
            print("error saving objecct to Realm \(error)")
        }
    }
    
    func stylingMethode() {
        
        recipeImage.layer.cornerRadius = 7
        rank.layer.cornerRadius = 7
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
