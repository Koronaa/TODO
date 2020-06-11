//
//  TaskTypeTableViewCell.swift
//  ToDo
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class TaskTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var categoryNameLabel: BodyLabel!
    @IBOutlet weak var taskCountLabel: BodyLabel!
    
    var task:Task!{
        didSet{
            UIHelper.addShadow(to: holderView)
            UIHelper.addCornerRadius(to: holderView)
            categoryNameLabel.text = task.category.name
            taskCountLabel.text = "4"
        }
    }
}
