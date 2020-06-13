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
    
    var taskTypeVM:TaskTypeViewModel!{
        didSet{
            UIHelper.addShadow(to: holderView)
            UIHelper.addCornerRadius(to: holderView)
            categoryNameLabel.text = taskTypeVM.name
            taskCountLabel.text = taskTypeVM.count.description
        }
    }
}
