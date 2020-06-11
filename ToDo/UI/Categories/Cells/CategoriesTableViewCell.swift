//
//  CategoriesTableViewCell.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var categoryNameLabel: BodyLabel!
    
    var category:Category!{
        didSet{
            setupUI()
            categoryNameLabel.text = category.name
        }
    }
    
    private func setupUI(){
        UIHelper.addCornerRadius(to: holderView)
    }
    
}
