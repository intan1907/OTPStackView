//
//  UITextField+Ext.swift
//  OTPStackView
//
//  Created by Intan Nurjanah on 08/09/22.
//

import UIKit

extension UITextField {
    
    /**
     Limit input to only number if `keyboardType` equals `UIKeyboardType.numberPad` or `UIKeyboardType.phonePad`
     
     - parameter string:    The replacement string for the specified range.
     */
    func limitNumberOnly(replacementString string: String) -> Bool {
        guard self.keyboardType == .numberPad || self.keyboardType == .phonePad else {
            return true
        }
        
        let invalidCharacters =
            CharacterSet(charactersIn: "0123456789").inverted
        return (string.rangeOfCharacter(from: invalidCharacters) == nil)
    }
    
}
