//
//  OTPStackView.swift
//  OTPStackView
//
//  Created by Intan Nurjanah on 08/09/22.
//

import UIKit

public class OTPStackView: UIStackView {
    
    // MARK: Variables
    
    private var numberOfFields: Int = 4
    private var textFieldItems: [OTPTextField] = []
    private var textFieldPreferences: OTPTextField.Preferences?
    private weak var delegate: OTPDelegate?
    
    // MARK: Initializers
    
    /**
     Initializes and returns a newly allocated `OTPStackView` object with the specified parameters.
     
     - Parameters:
        - numberOfFields:        The number of `OTPTextField`s in `OTPStackView`.
        - textFieldPreferences:  The preferences which will configure the `OTPTextField`s.
        - spacing:               The spacing between `OTPTextField`s.
        - delegate:              The delegate.
     */
    public init(
        numberOfFields: Int = 4,
        textFieldPreferences: OTPTextField.Preferences = OTPTextField.Preferences(),
        spacing: CGFloat = 8,
        delegate: OTPDelegate?
    ) {
        super.init(frame: .zero)
        
        self.numberOfFields = numberOfFields
        self.textFieldPreferences = textFieldPreferences
        self.spacing = spacing
        self.delegate = delegate
        
        self.configureInitialView()
        self.clearStack()
        self.addOTPFields()
    }
    
    /**
     NSCoding not supported. Use `init(numberOfFields:textFieldPreferences:spacing:delegate:)` instead!
     */
    public required init(coder: NSCoder) {
        fatalError("NSCoding not supported. Use init(numberOfFields:textFieldPreferences:spacing:delegate:) instead!")
    }
    
    // MARK: Public methods
    
    /**
     Returns OTP string from `OTPTextField`s.
     */
    public final func getOTP() -> String {
        var OTP = ""
        for textField in self.textFieldItems{
            OTP += textField.text ?? ""
        }
        return OTP
    }
    
    /**
     Clears the text of `OTPTextField`s.
     */
    public final func clearOTPText() {
        self.textFieldItems.forEach { field in
            field.text = ""
        }
    }
    
    // MARK: Private methods
    
    /**
     Configures the `OTPStackView` appearance and behavior.
     */
    private final func configureInitialView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
    }
    
    /**
     Removes all `arrangedSubviews` elements from the `OTPStackView`.
     */
    private final func clearStack() {
        self.arrangedSubviews.forEach { [weak self] vw in
            self?.removeArrangedSubview(vw)
            vw.removeFromSuperview()
        }
    }
    
    /**
     Creates a number of `OTPTextField`s and inserts them to the `OTPStackView`.
     */
    private final func addOTPFields() {
        for index in 0..<self.numberOfFields {
            let field = OTPTextField(preferences: self.textFieldPreferences)
            self.configureTextField(textField: field)
            self.textFieldItems.append(field)
            
            if index == 0 {
                field.previousTextField = nil
            } else {
                /// set the previous field of current field
                field.previousTextField = self.textFieldItems[index-1]
                /// set the next field of field at index-1
                self.textFieldItems[index-1].nextTextField = field
            }
        }
    }
    
    /**
     Configures the delegate and the size of `OTPTextField`.
     */
    private final func configureTextField(textField: UITextField) {
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        
        /// setup textField constraints
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        if let width = self.textFieldPreferences?.drawing.width {
            textField.widthAnchor.constraint(equalToConstant: width).isActive = true
        } else {
            textField.widthAnchor.constraint(equalTo: textField.heightAnchor).isActive = true
        }
    }
    
    /**
     Checks the `OTPTextField`s validity. The OTP is valid if all `OTPTextField`s are filled.
     */
    private final func validateFields() {
        for field in self.textFieldItems {
            if field.text == "" {
                self.delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        self.delegate?.didChangeValidity(isValid: true)
    }
    
    /**
     Fills the `OTPTextField`s with the first specified number of characters of`string`.
     */
    private final func autoFillTextField(with string: String) {
        var remainingStringStack: [String] = string.reversed().compactMap { String($0) }
        self.textFieldItems.forEach { field in
            if let charToAdd = remainingStringStack.popLast() {
                field.text = String(charToAdd)
            }
        }
        self.validateFields()
    }
    
}

// MARK: UITextFieldDelegate protocol implementation

extension OTPStackView: UITextFieldDelegate {
    
    /**
     Set the `OTPTextField` to active style after it begins the editing.
     */
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let tf = textField as? OTPTextField else { return }
        tf.setToActiveStyle()
    }
    
    /**
     Set the `OTPTextField` to inactive style after it ends the editing.
     */
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.validateFields()
        guard let tf = textField as? OTPTextField else { return }
        tf.setToInactiveStyle()
    }
    
    /**
     Switches between `OTPTextField`s.
     */
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
