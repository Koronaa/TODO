//
//  URL.swift
//  ToDo
//
//  Created by Sajith Konara on 6/12/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

extension URL {
    
    static var documentURL:URL{
        return try! FileManager
            .default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
}
