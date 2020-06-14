//
//  ValidationManager.swift
//  ToDo
//
//  Created by Sajith Konara on 6/14/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

protocol Validator {
    func isValid(_ value:String) -> Bool
}

enum ValidatorType{
    case basic
}

enum ValidatorFactory{
    static func validateFor(type:ValidatorType) -> Validator{
        switch type {
        case .basic:
            return BasicValidator()
        }
    }
}

struct BasicValidator:Validator {
    
    func isValid(_ value: String) -> Bool {
        return value.utf8.count > 0
    }
}
