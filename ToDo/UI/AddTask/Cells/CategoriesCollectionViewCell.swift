//
//  CategoriesCollectionViewCell.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var categoryLabel: SmallTitleLabel!
    
    var category:CategoryDTO!{
        didSet{
            setupUI()
            categoryLabel.text = category.name
            if category.isSelected{
                holderView.backgroundColor = .TODOYellow
            }else{
                holderView.backgroundColor = .white
            }
        }
    }
    
    private func setupUI(){
        UIHelper.addCornerRadius(to: holderView, withborder: true, using: UIColor.black.cgColor)
    }
}
