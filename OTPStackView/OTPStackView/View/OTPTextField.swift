//
//  OTPTextField.swift
//  OTPStackView
//
//  Created by Intan Nurjanah on 08/09/22.
//

import UIKit

open class OTPTextField: UITextField {
    
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    
    public struct Preferences {
        public struct Drawing {
            public var backgroundColor: UIColor = .white
            public var textColor: UIColor = .black
            public var cornerRadius: CGFloat = 8
            public var width: CGFloat? = nil
            public var inactiveBorderWidth: CGFloat = 1
            public var inactiveBorderColor: UIColor = .lightGray
            public var activeBorderWidth: CGFloat = 2
            public var activeBorderColor: UIColor = .cyan
            
            public init() { }
        }
        
        public struct TextInputTraits {
            public var font: UIFont = .systemFont(ofSize: 16)
            public var textAlignment: NSTextAlignment = .center
            public var adjustsFontSizeToFitWidth: Bool = false
            public var keyboardType: UIKeyboardType = .numberPad
            public var autocorrectionType: UITextAutocorrectionType = .yes
            
            public init() { }
        }
        
        public var drawing: Drawing = Drawing()
        public var textInputTraits: TextInputTraits = TextInputTraits()
        
        public init() { }
    }
    
    private var preferences: Preferences!
    
    public convenience init() {
        self.init(preferences: Preferences())
    }
    
    public init(preferences: Preferences?) {
        super.init(frame: .zero)
        
        if let pref = preferences {
            self.preferences = pref
        } else {
            self.preferences = Preferences()
        }
        
        self.configureView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("NSCoding not supported. Use init(drawing:textInputTraits:) instead!")
    }
    
    public override func deleteBackward() {
        self.text = ""
        self.previousTextField?.becomeFirstResponder()
    }
    
    public func setToActiveStyle() {
        self.layer.borderColor = self.preferences.drawing.activeBorderColor.cgColor
        self.layer.borderWidth = self.preferences.drawing.activeBorderWidth
    }
    
    public func setToInactiveStyle() {
        self.layer.borderColor = self.preferences.drawing.inactiveBorderColor.cgColor
        self.layer.borderWidth = self.preferences.drawing.inactiveBorderWidth
    }
    
    private func configureView() {
        // set drawing settings
        self.backgroundColor = self.preferences.drawing.backgroundColor
        self.textColor = self.preferences.drawing.textColor
        self.layer.cornerRadius = self.preferences.drawing.cornerRadius
        self.layer.borderWidth = self.preferences.drawing.inactiveBorderWidth
        self.layer.borderColor = self.preferences.drawing.inactiveBorderColor.cgColor
        
        // set text input traits settings
        self.font = self.preferences.textInputTraits.font
        self.textAlignment = self.preferences.textInputTraits.textAlignment
        self.adjustsFontSizeToFitWidth = self.preferences.textInputTraits.adjustsFontSizeToFitWidth
        self.keyboardType = self.preferences.textInputTraits.keyboardType
        self.autocorrectionType = self.preferences.textInputTraits.autocorrectionType
        
        if #available(iOS 12.0, *) {
            self.textContentType = .oneTimeCode
        }
    }
    
}
