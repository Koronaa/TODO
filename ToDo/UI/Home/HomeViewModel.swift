//
//  HomeViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
class HomeViewModel{
    
    var featuredItems:[Featured] {
        return Featured.getFeatures()
    }
    
    var getTodos:[Task]{
        return Task.getTodos()
    }
}
