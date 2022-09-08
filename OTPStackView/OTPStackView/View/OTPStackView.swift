//
//  OTPStackView.swift
//  OTPStackView
//
//  Created by Intan Nurjanah on 08/09/22.
//

import UIKit

public class OTPStackView: UIStackView {
    
    // MARK: Field properties
    private var numberOfFields: Int = 4
    private var textFieldItems: [OTPTextField] = []
    public weak var delegate: OTPDelegate?
    
    private var remainingStringStack: [String] = []
    
    public init(numberOfFields: Int = 4, delegate: OTPDelegate?) {
        super.init(frame: .zero)
        
        self.numberOfFields = numberOfFields
        self.delegate = delegate
        
        self.configureInitialView()
        self.clearStack()
        self.addOTPFields()
    }
    
    public required init(coder: NSCoder) {
        fatalError("NSCoding not supported. Use init(numberOfFields:delegate:) instead!")
    }
    
    // gives the OTP text
    public final func getOTP() -> String {
        var OTP = ""
        for textField in self.textFieldItems{
            OTP += textField.text ?? ""
        }
        return OTP
    }
    
    public final func clearOTPText() {
        self.textFieldItems.forEach { field in
            field.text = ""
        }
    }
    
    private final func configureInitialView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 8
    }
    
    private final func clearStack() {
        self.arrangedSubviews.forEach { [weak self] vw in
            self?.removeArrangedSubview(vw)
            vw.removeFromSuperview()
        }
    }
    
    /// Adding each OTPfield to stack view
    private final func addOTPFields() {
        for index in 0..<self.numberOfFields {
            let field = OTPTextField()
            self.configureTextField(textField: field)
            self.textFieldItems.append(field)
            
            if index == 0 {
                field.previousTextField = nil
            } else {
                /// set previous field for current field
                field.previousTextField = self.textFieldItems[index-1]
                /// set next field for field at index-1
                self.textFieldItems[index-1].nextTextField = field
            }
        }
    }
    
    private final func configureTextField(textField: UITextField) {
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        
        // setup textField constraints
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private final func validateFields() {
        for field in self.textFieldItems {
            if field.text == "" {
                self.delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        self.delegate?.didChangeValidity(isValid: true)
    }
    
    /// autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        self.remainingStringStack = string.reversed().compactMap { String($0) }
        self.textFieldItems.forEach { field in
            if let charToAdd = self.remainingStringStack.popLast() {
                field.text = String(charToAdd)
            }
        }
        self.validateFields()
        self.remainingStringStack = []
    }
    
}

extension OTPStackView: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let tf = textField as? OTPTextField else { return }
        tf.setToActiveStyle()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.validateFields()
        guard let tf = textField as? OTPTextField else { return }
        tf.setToInactiveStyle()
    }
    
    /// switches between OTPTextfields
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField else { return true }
        
        guard textField.limitNumberOnly(replacementString: string)
        else { return false }
        
        if string.count > 1 {
            textField.resignFirstResponder()
            self.autoFillTextField(with: string)
            return false
        } else if range.length == 0 {
            guard !string.isEmpty else {
                /// autofill from suggestion will give empty string twice before give the actual code
                /// thus, in order to skip those empty string, set the first field to become first responder
                /// so that the actual code start to fill in the first field
                self.textFieldItems[0].becomeFirstResponder()
                return true
            }
            if textField.nextTextField == nil {
                textField.text = string
                textField.resignFirstResponder()
            } else {
                textField.text = string
                textField.nextTextField?.becomeFirstResponder()
            }
            return false
        }
        return true
    }
    
}
