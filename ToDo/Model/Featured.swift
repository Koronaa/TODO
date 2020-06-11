//
//  Featured.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

struct Featured{
    
    var name:String
    var subTitile:String?
    var image:UIImage?
    
    static func getFeatures() -> [Featured]{
        var features:[Featured] = []
        
        features.append(Featured(name: "Today", subTitile: Date().today, image: nil))
        features.append(Featured(name: "Tomorrow", subTitile: Date().tomorrow, image: nil))
        features.append(Featured(name: "This Month", subTitile: Date().month, image: nil))
        features.append(Featured(name: "This Week", subTitile: "Week \(Date().weakNumber)", image: nil))
        features.append(Featured(name: "Favourites", subTitile: nil, image: UIImage(named: "favourite_filled")!))
        
        return features
    }
    
}
