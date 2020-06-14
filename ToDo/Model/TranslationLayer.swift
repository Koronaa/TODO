//
//  TranslationLayer.swift
//  ToDo
//
//  Created by Sajith Konara on 6/14/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
class TranslationLayer{
    
    func convetToCategoryDTO(categories:[Category]) -> [CategoryDTO]{
        var dtos = [CategoryDTO]()
        for category in categories{
            dtos.append(CategoryDTO(name: category.name, isSelected: false))
        }
        return dtos
    }
}
