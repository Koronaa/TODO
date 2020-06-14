//
//  UITextField.swift
//  ToDo
//
//  Created by Sajith Konara on 6/14/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import UIKit

extension UITextField {
    func validateText(validationType:ValidatorType) -> Bool {
        let validator  = ValidatorFactory.validateFor(type: validationType)
        return validator.isValid(self.text!)
    }
}
