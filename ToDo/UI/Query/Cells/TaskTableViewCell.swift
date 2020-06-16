//
//  TaskTableViewCell.swift
//  ToDo
//
//  Created by Sajith Konara on 6/10/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundHolerView: UIView!
    @IBOutlet weak var taskLabel: BodyLabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    var taskTableViewVM:TaskTableViewViewModel!{
        didSet{
            setupUI()
            taskLabel.text = taskTableViewVM.taskName
            dateTimeLabel.text = taskTableViewVM.dateString
        }
    }
    
    private func setupUI(){
//        UIHelper.addShadow(to: backgroundHolerView)
        UIHelper.addCornerRadius(to: backgroundHolerView)
        dateTimeLabel.font = UIFont(name: "Montserrat-Thin", size: 11)
    }
    
}
