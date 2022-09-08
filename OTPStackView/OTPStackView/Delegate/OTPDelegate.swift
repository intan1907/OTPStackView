//
//  OTPDelegate.swift
//  OTPStackView
//
//  Created by Intan Nurjanah on 08/09/22.
//

import Foundation

public protocol OTPDelegate: NSObject {
    
    // always triggers when the OTP field is valid
    func didChangeValidity(isValid: Bool)
    
}
