//
//  AddTaskViewController.swift
//  ToDo
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var addNewCategoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupUI(){
        dateTimeLabel.font = UIFont(name: "Montserrat-Bold", size: 23.0)
        
    }
    

    

}
