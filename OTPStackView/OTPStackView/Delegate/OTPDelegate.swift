//
//  OTPDelegate.swift
//  OTPStackView
//
//  Created by Intan Nurjanah on 08/09/22.
//

import Foundation

public protocol OTPDelegate: NSObject {
    
    /**
     Always triggers when the `OTPStackView` text is valid.
     
     - parameter isValid :  Pass `true` if the OTP fields are filled.
     */
    func didChangeValidity(isValid: Bool)
    
}
