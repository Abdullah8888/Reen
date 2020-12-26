//
//  HomeViewControllerViewController.swift
//  Reen
//
//  Created by Jimoh Babatunde Olalekan on 26/12/2020.
//  Copyright © 2020 Jimoh Babatunde Olalekan. All rights reserved.
//

import UIKit

class HomeViewControllerViewController: GenericViewController {

    @IBOutlet weak var pinImage: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNavigationBar(state: .withEmpty)
        self.pinImage?.layer.borderWidth = 1
        self.pinImage?.layer.borderColor = UIColor.black.cgColor
    }

    

}
