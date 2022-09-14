//
//  OTPTextField.swift
//  OTPStackView
//
//  Created by Intan Nurjanah on 08/09/22.
//

import UIKit

open class OTPTextField: UITextField {
    
    // MARK: Nested types
    
    /**
     The preferences which will configure the appearance and behavior of `OTPTextField`.
     */
    public struct Preferences {
        
        /**
         Customizable properties specifying how `OTPTextField` will be drawn on screen.
         */
        public struct Drawing {
            public var backgroundColor: UIColor = .white
            public var textColor: UIColor = .black
            public var cornerRadius: CGFloat = 8
            public var width: CGFloat? = nil
            public var inactiveBorderWidth: CGFloat = 1
            public var inactiveBorderColor: UIColor = .lightGray
            public var activeBorderWidth: CGFloat = 2
            public var activeBorderColor: UIColor = .cyan
        }
        
        /**
         Customizable properties specifying features for keyboard input to `OTPTextField`.
         */
        public struct TextInputTraits {
            public var font: UIFont = .systemFont(ofSize: 16)
            public var textAlignment: NSTextAlignment = .center
            public var adjustsFontSizeToFitWidth: Bool = false
            public var keyboardType: UIKeyboardType = .numberPad
            public var autocorrectionType: UITextAutocorrectionType = .yes
        }
        
        public var drawing: Drawing = Drawing()
        public var textInputTraits: TextInputTraits = TextInputTraits()
        
        public init() { }
        
    }
    
    // MARK: Variables
    
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
        
    private var preferences: Preferences!
    
    // MARK: Initializers
    
    /**
     Initializes and returns a newly allocated `OTPTextField` object with the default `perferences` value.
     */
    public convenience init() {
        self.init(preferences: Preferences())
    }
    
    /**
     Initializes and returns a newly allocated `OTPTextField` object with the specified `perferences`.
     
     - parameter preferences:   The preferences which will configure the `OTPTextField`.
     */
    public init(preferences: Preferences?) {
        super.init(frame: .zero)
        
        if let pref = preferences {
            self.preferences = pref
        } else {
            self.preferences = Preferences()
        }
        
        self.configureView()
    }
    
    /**
     NSCoding not supported. Use `init(preferences:)` instead!
     */
    required public init?(coder: NSCoder) {
        fatalError("NSCoding not supported. Use init(preferences:) instead!")
    }
    
    /**
     Set the `previousTextField` to be the first responder after user pressed the delete key.
     */
    public override func deleteBackward() {
        self.text = ""
        self.previousTextField?.becomeFirstResponder()
    }
    
    // MARK: Public methods
    
    /**
     Set `OTPTextField` appearance to the active style.
     */
    public func setToActiveStyle() {
        self.layer.borderColor = self.preferences.drawing.activeBorderColor.cgColor
        self.layer.borderWidth = self.preferences.drawing.activeBorderWidth
    }
    
    /**
     Set `OTPTextField` appearance to the inactive style.
     */
    public func setToInactiveStyle() {
        self.layer.borderColor = self.preferences.drawing.inactiveBorderColor.cgColor
        self.layer.borderWidth = self.preferences.drawing.inactiveBorderWidth
    }
    
    // MARK: Private methods
    
    /**
     Set `OTPTextField` appearance based on `preferences`.
     */
    private func configureView() {
        /// set drawing settings
        self.backgroundColor = self.preferences.drawing.backgroundColor
        self.textColor = self.preferences.drawing.textColor
        self.layer.cornerRadius = self.preferences.drawing.cornerRadius
        self.layer.borderWidth = self.preferences.drawing.inactiveBorderWidth
        self.layer.borderColor = self.preferences.drawing.inactiveBorderColor.cgColor
        
        /// set text input traits settings
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
