//
//  MODEL.swift
//  Food To Fork
//
//  Created by IOS System on 8/25/19.
//  Copyright © 2019 IOS Systems. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Requests {
    static let Key = "4cd4e08966ac79cf56877ab950cc62b4"
    static let SearchUrl = "https://www.food2fork.com/api/search"
    static let GetUrl = "https://www.food2fork.com/api/get"
    static let sharedInstance = Requests()
    func getData(withURL url:String , parameters : [String:String] ,Completion: @escaping (JSON) -> ()) {
        
        Alamofire.request(url , method: .get , parameters : parameters).responseJSON { response in
            if response.result.isSuccess{
                print("Success!!")
                
                let json : JSON = JSON(response.result.value!)
                
                Completion(json)
                
            }else{
                print("Request failed \(String(describing: response.result.error))")
            }
        }
    }
}
