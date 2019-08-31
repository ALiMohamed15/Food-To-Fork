//
//  StartView.swift
//  Food To Fork
//
//  Created by IOS System on 8/31/19.
//  Copyright © 2019 IOS Systems. All rights reserved.
//

import UIKit

class StartView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.performSegue(withIdentifier: "Start", sender: nil)
        }
    }

}
