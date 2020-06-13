//
//  Featured.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

enum FeaturedType{
    case Today
    case Tomorrow
    case Month
    case Week
    case Favourite
}

struct Featured{
    
    var name:String
    var type:FeaturedType
    var subTitile:String?
    var image:UIImage?
    
    static func getFeatures() -> [Featured]{
        var features:[Featured] = []
        
        features.append(Featured(name: "Today", type: .Today,subTitile: Date().today, image: nil))
        features.append(Featured(name: "Tomorrow", type: .Tomorrow, subTitile: Date().tomorrow, image: nil))
        features.append(Featured(name: "This Month", type: .Month, subTitile: Date().month, image: nil))
        features.append(Featured(name: "This Week", type: .Week, subTitile: "Week \(Date().weakNumber)", image: nil))
        features.append(Featured(name: "Favourites", type: .Favourite, subTitile: nil, image: UIImage(named: "favourite_filled")!))
        
        return features
    }
    
}
