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

    let apiKey:String = "Key"
    let RecepiesURL:String = "https://www.food2fork.com/api/search"
    
    
    var prams : [String : String] = [:]
    
    var titleArray = [String]()
    var imageURLArray = [String]()
    var puplisherArray = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        prams = ["key" : apiKey]
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
        imageURLArray = images
        titleArray = titles
        puplisherArray = ingred
        collection.reloadData()
    }
    
    
    
    
}


// MARK: Set up CollectionView

extension ViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath)as! CellVC
        
        cell.image.sd_setImage(with: URL(string: imageURLArray[indexPath.row]), placeholderImage: nil)
        
        cell.title.text = titleArray[indexPath.row]
        cell.publisher.text = puplisherArray[indexPath.row]
        return cell
    }
    
    
}
