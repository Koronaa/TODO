//
//  FeaturedCollectionViewViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/15/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

class FeaturedCollectionViewViewModel {
    
    var featuredItem:Featured
    
    init(featuredItem:Featured) {
        self.featuredItem = featuredItem
    }
    
    var name:String{
        featuredItem.name
    }
    
    var subTitile:String?{
        return featuredItem.subTitile
    }
    
    var itemImage:UIImage?{
        return featuredItem.image
    }
}
