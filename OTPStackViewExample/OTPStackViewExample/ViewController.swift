//
//  ViewController.swift
//  OTPStackViewExample
//
//  Created by Intan Nurjanah on 09/09/22.
//

import OTPStackView

class ViewController: UIViewController {

    @IBOutlet weak var otpContainerView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    private var otpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    private func configureView() {
        // setup otp view
        var preferences = OTPTextField.Preferences()
        preferences.drawing.inactiveBorderColor = .lightGray
        preferences.drawing.activeBorderColor = .systemOrange
        self.otpView = OTPStackView(
            numberOfFields: 6,
            textFieldPreferences: preferences,
            spacing: 8,
            delegate: self
        )
        self.otpContainerView.addSubview(self.otpView)
        
        // set otp view constraints
        self.otpView.topAnchor.constraint(
            equalTo: self.otpContainerView.topAnchor
        ).isActive = true
        self.otpView.leadingAnchor.constraint(
            equalTo: self.otpContainerView.leadingAnchor
        ).isActive = true
        self.otpView.trailingAnchor.constraint(
            equalTo: self.otpContainerView.trailingAnchor
        ).isActive = true
        self.otpView.bottomAnchor.constraint(
            equalTo: self.otpContainerView.bottomAnchor
        ).isActive = true
        
        // setup button style
        self.setButtonStyle(isEnable: false)
    }
    
    private func setButtonStyle(isEnable: Bool) {
        if isEnable {
            self.continueButton.backgroundColor = .systemOrange
            self.continueButton.setTitleColor(.white, for: .normal)
        } else {
            self.continueButton.backgroundColor = .lightGray
            self.continueButton.setTitleColor(.systemGray4, for: .normal)
        }
    }

}

extension ViewController: OTPDelegate {
    
    func didChangeValidity(isValid: Bool) {
        self.setButtonStyle(isEnable: isValid)
    }
    
}
