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
    
    public struct Drawing {
        public var backgroundColor: UIColor = .white
        public var textColor: UIColor = .black
        public var cornerRadius: CGFloat = 8
        public var inactiveBorderWidth: CGFloat = 1
        public var inactiveBorderColor: UIColor = .lightGray
        public var activeBorderWidth: CGFloat = 2
        public var activeBorderColor: UIColor = .cyan
    }
    
    public struct TextInputTraits {
        public var font: UIFont = .systemFont(ofSize: 16)
        public var textAlignment: NSTextAlignment = .center
        public var adjustsFontSizeToFitWidth: Bool = false
        public var keyboardType: UIKeyboardType = .numberPad
        public var autocorrectionType: UITextAutocorrectionType = .yes
    }
    
    private var drawing: Drawing!
    private var textInputTraits: TextInputTraits!
    
    public convenience init() {
        self.init(drawing: Drawing(), textInputTraits: TextInputTraits())
    }
    
    public init(drawing: Drawing, textInputTraits: TextInputTraits) {
        super.init(frame: .zero)
        self.drawing = drawing
        self.textInputTraits = textInputTraits
        
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
        self.layer.borderColor = self.drawing.activeBorderColor.cgColor
        self.layer.borderWidth = self.drawing.activeBorderWidth
    }
    
    public func setToInactiveStyle() {
        self.layer.borderColor = self.drawing.inactiveBorderColor.cgColor
        self.layer.borderWidth = self.drawing.inactiveBorderWidth
    }
    
    private func configureView() {
        // set drawing settings
        self.backgroundColor = self.drawing.backgroundColor
        self.textColor = self.drawing.textColor
        self.layer.cornerRadius = self.drawing.cornerRadius
        self.layer.borderWidth = self.drawing.inactiveBorderWidth
        self.layer.borderColor = self.drawing.inactiveBorderColor.cgColor
        
        // set text input traits settings
        self.font = self.textInputTraits.font
        self.textAlignment = self.textInputTraits.textAlignment
        self.adjustsFontSizeToFitWidth = self.textInputTraits.adjustsFontSizeToFitWidth
        self.keyboardType = self.textInputTraits.keyboardType
        self.autocorrectionType = self.textInputTraits.autocorrectionType
        
        if #available(iOS 12.0, *) {
            self.textContentType = .oneTimeCode
        }
    }
    
}
