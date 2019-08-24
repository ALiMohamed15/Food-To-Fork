//
//  ViewController.swift
//  Food To Fork
//
//  Created by IOS System on 8/21/19.
//  Copyright © 2019 IOS Systems. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var collection: UICollectionView!

    let apiKey:String = "c34e5bd22e22eb9b4250014a38dbb85d"
    let RecepiesURL:String = "https://www.food2fork.com/api/search"
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var prams : [String : String] = [:]
    
    var q = ""
    var titleArray = [String]()
    var imageURLArray = [String]()
    var puplisherArray = [String]()
    var rid = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        makeRequest()
        
        SearchBar.delegate = self
    }
    
    func makeRequest(){
        
        prams = ["key" : apiKey , "q" : q ]
        getData(withURL: RecepiesURL, parameters: prams)
        
    }
    
    // MARK : Request Data From API Method

    func getData(withURL url:String , parameters : [String:String]) {
        
        Alamofire.request(url , method: .get , parameters : parameters).responseJSON { response in
            if response.result.isSuccess{
                print("Success!!")
                
                let json : JSON = JSON(response.result.value!)
                
                self.UpdateJSONdata(with: json)
            }else{
                print("Request failed \(String(describing: response.result.error))")
            }
        }
    }
    
    // MARK: JSON Data Method
    
    func UpdateJSONdata(with json:JSON) {
        
        let titles = json["recipes"].arrayValue.map {$0["title"].stringValue}
        let images = json["recipes"].arrayValue.map {$0["image_url"].stringValue}
        let ingred = json["recipes"].arrayValue.map {$0["publisher"].stringValue}
        let recipiesID = json["recipes"].arrayValue.map {$0["recipe_id"].stringValue}
        
        rid = recipiesID
        imageURLArray = images
        titleArray = titles
        puplisherArray = ingred
        collection.reloadData()
    }
    
}



//MARK: Search Bar Methodes

extension ViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            q = text
            makeRequest()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                self.q = ""
                searchBar.resignFirstResponder()
                self.makeRequest()
            }
        }
    }
    
}



// MARK: Set up CollectionView

extension ViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath)as! CellVC
        
        cell.image.sd_setImage(with: URL(string: imageURLArray[indexPath.row]), placeholderImage: UIImage(named: "Food Icon"))
        
        cell.title.text = titleArray[indexPath.row]
        cell.publisher.text = puplisherArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        vc.recipeID = rid[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
