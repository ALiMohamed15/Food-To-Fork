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

struct CELLLLL {
    var titleArray = [String]()
    var imageURLArray = [String]()
    var puplisherArray = [String]()
    var rid = [String]()
}


class ViewController: UIViewController {
    
    //    4cd4e08966ac79cf56877ab950cc62b4
    //    c34e5bd22e22eb9b4250014a38dbb85d

    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var prams : [String : String] = [:]
    var q = ""
    var items = [CELLLLL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        SearchBar.delegate = self

        setUpNib()
        makeRequest()
        delayFunction()
    }
    
   
    
    // MARK : Request Data From API Method
    func makeRequest(){
        prams = ["key" : Requests.Key , "q" : q ]
        Requests.sharedInstance.getData(withURL: Requests.SearchUrl, parameters: prams) { (JSON) in
            self.UpdateData(with: JSON)
            self.dataError()
        }
    }
    
    // MARK: JSON Data Method
    
    func UpdateData(with json:JSON) {
        
        let titles = json["recipes"].arrayValue.map {$0["title"].stringValue}
        let images = json["recipes"].arrayValue.map {$0["image_url"].stringValue}
        let puplisher = json["recipes"].arrayValue.map {$0["publisher"].stringValue}
        let recipiesID = json["recipes"].arrayValue.map {$0["recipe_id"].stringValue}
        
        items = [CELLLLL.init(titleArray: titles, imageURLArray: images, puplisherArray: puplisher, rid: recipiesID)]
        
        TableView.reloadData()
        
    }
    
    //MARK : Delay Other Functions
    func delayFunction()  {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.dataError()
        })
    }
    
    // MARK : Display error Screen method
    func dataError() {
        let errorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        if TableView.numberOfRows(inSection: 0) == 0 {
            errorView.tag = 100
            errorView.backgroundColor = .white
            let image = UIImageView(frame: CGRect(x: errorView.frame.width / 2 - 100 , y: errorView.frame.height / 2 - 100, width: 200 , height: 200))
            image.image = UIImage(named: "connection error")
            
            let message = UILabel(frame: CGRect(x: errorView.frame.width/2 - 100
                , y: errorView.frame.height/2 + 100, width: 200, height: 25))
            message.text = "Connection Error"
            message.textColor = .red
            message.textAlignment = .center
            message.font = UIFont(name: "Futura-Bold", size: 20)
            
            errorView.addSubview(image)
            errorView.addSubview(message)
            self.view.addSubview(errorView)
        }
        else{
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        }
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





//MARK : set up tableview

extension ViewController : UITableViewDataSource,UITableViewDelegate {
    
    func setUpNib(){
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        TableView.register(nib, forCellReuseIdentifier: "CellXIB")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.first?.titleArray.count ?? 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellXIB", for: indexPath) as! TableViewCell

        if let imageURL = items.first?.imageURLArray[indexPath.row] {
            cell.rImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "Food Icon"))
            
            cell.Title.text = items.first!.titleArray[indexPath.row]
            
            cell.Puplisher.text = items.first!.puplisherArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        vc.recipeID = (items.first?.rid[indexPath.row])!
        vc.navigationItem.title = items.first?.titleArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
