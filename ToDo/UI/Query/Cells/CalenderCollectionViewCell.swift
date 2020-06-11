//
//  CalenderCollectionViewCell.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class CalenderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectionIndicatorView: UIView!
    
    var day:Day!{
        didSet{
            setupUI()
            dayLabel.text = day.name
            dateLabel.text = day.date
            
            if day.isSelected{
                UIHelper.show(view: selectionIndicatorView)
                dayLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
                dateLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
            }else{
                UIHelper.hide(view: selectionIndicatorView)
                dayLabel.font = UIFont(name: "Montserrat-Regular", size: 18.0)
                dateLabel.font = UIFont(name: "Montserrat-Regular", size: 18.0)
            }
        }
    }
    
    
    private func setupUI(){
        UIHelper.circular(view: selectionIndicatorView)
    }

}
