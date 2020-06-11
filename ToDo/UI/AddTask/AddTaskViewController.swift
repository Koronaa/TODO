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
        
        //TODO:
        let categoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(addCategotyLabelOnTapped))
        addNewCategoryLabel.addGestureRecognizer(categoryTapGesture)
        
    }
    
    fileprivate func setupUI(){
        dateTimeLabel.font = UIFont(name: "Montserrat-Bold", size: 23.0)
        
    }
    
    @IBAction func closeButtonOnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func addCategotyLabelOnTapped(){
        let categoryModelVC = UIHelper.makeViewController(viewControllerName: .CategoriesVC) as! CategoriesViewController
        self.modalPresentationStyle = .currentContext
        self.present(categoryModelVC, animated: true, completion: nil)
        
    }
    
    

}
