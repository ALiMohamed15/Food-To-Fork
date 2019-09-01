//
//  FavoritesView.swift
//  Food To Fork
//
//  Created by IOS System on 8/31/19.
//  Copyright © 2019 IOS Systems. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class FavoritesView: UIViewController {

    let realm = try! Realm()
    
    var Recipies: Results<Recipe>?
    
    
    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.dataSource = self
        TableView.delegate = self
        
        Recipies = realm.objects(Recipe.self)
    }

}



extension FavoritesView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Recipies?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! FavCell
        if let url = Recipies?[indexPath.row].image {
            
            cell.title.text = Recipies?[indexPath.row].title ?? "No"
            cell.Pic.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Food Icon"))
        }
       
       
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 177
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "FavDetails") as! FavDetailsVC
        
        if let item = Recipies?[indexPath.row] {
            VC.rank = item.rank
            VC.ttitle = item.title
            VC.image = item.image
            
            for i in item.ingerdients.indices {
                VC.ingredsArray.append(item.ingerdients[i])
            }
            
        }
        
        
        navigationController?.pushViewController(VC, animated: true)
    }
    
}
