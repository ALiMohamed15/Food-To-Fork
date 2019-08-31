//
//  SaveDataModel.swift
//  Food To Fork
//
//  Created by IOS System on 8/31/19.
//  Copyright © 2019 IOS Systems. All rights reserved.
//

import UIKit
import RealmSwift

class Recipe : Object {
    
    @objc dynamic var title = ""
    @objc dynamic var rank = ""
    @objc dynamic var image  = ""
    var ingerdients = List<String>()
    
}
