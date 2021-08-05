//
//  EmailCell.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 2/8/2564 BE.
//

import UIKit
import Core
import JVFloatLabeledTextField

class EmailCell: UICollectionViewCell {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var alertLabel: UILabel!
    @IBOutlet var emailView: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var emailTextField: JVFloatLabeledTextField! {
        didSet {
            self.emailTextField.font = UIFont.asset(.regular, fontSize: .body)
            self.emailTextField.placeholder = "Email"
            self.emailTextField.placeholderColor = UIColor.Asset.gray
            self.emailTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.emailTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.emailTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.emailTextField.textColor = UIColor.Asset.white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.emailView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.welcomeLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.welcomeLabel.textColor = UIColor.Asset.white
        self.alertLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.alertLabel.textColor = UIColor.Asset.white
        self.loginButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.loginButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.setupNextButton(isActive: false)
        
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupNextButton(isActive: Bool) {
        self.nextButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        
        if isActive {
            self.nextButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.nextButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }
    
    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 500)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.isEmpty {
            self.setupNextButton(isActive: false)
        } else {
            self.setupNextButton(isActive: true)
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if !(self.emailTextField.text!.isEmpty) {
            self.endEditing(true)
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.createPassword), animated: true)
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.endEditing(true)
        Utility.currentViewController().navigationController?.popViewController(animated: true)
    }
}
