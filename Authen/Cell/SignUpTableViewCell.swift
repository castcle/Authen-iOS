//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  SignUpTableViewCell.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 6/5/2565 BE.
//

import UIKit
import Core

class SignUpTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var confirmPasswordLabel: UILabel!
    
    @IBOutlet var emailView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var confirmPasswordView: UIView!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var emailAlertLabel: UILabel!
    
    
    
    @IBOutlet var limitCharLabel: UILabel!
    @IBOutlet var typeCharLabel: UILabel!
    @IBOutlet var passwordNotMatchLabel: UILabel!
//    @IBOutlet var applyButton: UIButton!
    
    @IBOutlet var showPasswordButton: UIButton!
    @IBOutlet var showConfirmPasswordButton: UIButton!
    @IBOutlet var charCountImage: UIImageView!
    @IBOutlet var charTypeImage: UIImageView!
    @IBOutlet var passwordNotMatchImage: UIImageView!
    
    var viewModel = SignUpViewModel()
    
    private var isCanContinue: Bool {
        self.checkCharacterCount()
        self.checkCharacterType()
        self.checkPasswordNotMatch()
        if self.passwordTextField.text!.isEmpty || self.confirmPasswordTextField.text!.isEmpty {
            return false
        } else if self.passwordTextField.text!.count < 6 || self.passwordTextField.text!.count > 20 {
            return false
        } else if !self.passwordTextField.text!.isPassword {
            return false
        } else if self.passwordTextField.text != self.confirmPasswordTextField.text {
            return false
        } else {
            return true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.passwordLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.passwordLabel.textColor = UIColor.Asset.white
        self.confirmPasswordLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.confirmPasswordLabel.textColor = UIColor.Asset.white
        
        self.emailTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.emailTextField.textColor = UIColor.Asset.white
        self.passwordTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.passwordTextField.textColor = UIColor.Asset.white
        self.passwordTextField.isSecureTextEntry = true
        self.confirmPasswordTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.confirmPasswordTextField.textColor = UIColor.Asset.white
        self.confirmPasswordTextField.isSecureTextEntry = true
        
        self.emailView.capsule(color: UIColor.Asset.darkGray)
        self.passwordView.capsule(color: UIColor.Asset.darkGray)
        self.confirmPasswordView.capsule(color: UIColor.Asset.darkGray)
        
        self.emailTextField.tag = 0
        self.emailTextField.delegate = self
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.passwordTextField.delegate = self
        self.passwordTextField.tag = 1
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.confirmPasswordTextField.delegate = self
        self.confirmPasswordTextField.tag = 2
        self.confirmPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        
        self.emailAlertLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.emailAlertLabel.textColor = UIColor.Asset.white
        self.emailAlertLabel.isHidden = true
        self.limitCharLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.limitCharLabel.textColor = UIColor.Asset.gray
        self.typeCharLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.typeCharLabel.textColor = UIColor.Asset.gray
        self.passwordNotMatchLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.passwordNotMatchLabel.textColor = UIColor.Asset.gray
        
        self.showPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.showConfirmPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.charCountImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        self.charTypeImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        self.passwordNotMatchImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        
        
        
        self.viewModel.didCheckEmailExistsFinish = {
            self.emailTextField.isEnabled = true
            if self.viewModel.isEmailExist {
                self.emailAlertLabel.isHidden = false
                self.emailAlertLabel.text  = Localization.registerCheckEmail.alertEmailInvalid.text
                self.emailAlertLabel.textColor = UIColor.Asset.denger
            } else {
                self.emailAlertLabel.isHidden = false
                self.emailAlertLabel.text  = Localization.registerCheckEmail.alertEmailValid.text
                self.emailAlertLabel.textColor = UIColor.Asset.lightBlue
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.passwordTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            self.confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            let email: String = textField.text ?? ""
            if email.isEmpty {
                self.emailAlertLabel.isHidden = true
                self.emailAlertLabel.text  = Localization.registerCheckEmail.alertNotice.text
                self.emailAlertLabel.textColor = UIColor.Asset.white
            } else if email.isEmail {
                textField.isEnabled = false
                self.viewModel.authenRequest.payload.email = email
                self.viewModel.checkEmailExists()
            } else {
                self.emailAlertLabel.isHidden = false
                self.emailAlertLabel.text  = Localization.registerCheckEmail.alertWrongFormat.text
                self.emailAlertLabel.textColor = UIColor.Asset.denger
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0 {
            self.emailAlertLabel.isHidden = true
        } else {
            self.setupContinueButton(isActive: self.isCanContinue)
        }
    }
    
    private func setupContinueButton(isActive: Bool) {
//        self.applyButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
//        if isActive {
//            self.applyButton.setTitleColor(UIColor.Asset.white, for: .normal)
//            self.applyButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
//            self.applyButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
//        } else {
//            self.applyButton.setTitleColor(UIColor.Asset.gray, for: .normal)
//            self.applyButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
//            self.applyButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
//        }
    }
    
    private func checkCharacterCount() {
        if self.passwordTextField.text!.count < 6 || self.passwordTextField.text!.count > 20 {
            self.limitCharLabel.textColor = UIColor.Asset.gray
            self.charCountImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        } else {
            self.limitCharLabel.textColor = UIColor.Asset.lightBlue
            self.charCountImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
        }
    }
    
    private func checkCharacterType() {
        if self.passwordTextField.text!.isPassword {
            self.typeCharLabel.textColor = UIColor.Asset.lightBlue
            self.charTypeImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
        } else {
            self.typeCharLabel.textColor = UIColor.Asset.gray
            self.charTypeImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        }
    }
    
    private func checkPasswordNotMatch() {
        if !(self.confirmPasswordTextField.text!.isEmpty) && (self.passwordTextField.text! == self.confirmPasswordTextField.text!) {
            self.passwordNotMatchLabel.textColor = UIColor.Asset.lightBlue
            self.passwordNotMatchImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
        } else {
            self.passwordNotMatchLabel.textColor = UIColor.Asset.gray
            self.passwordNotMatchImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        }
    }
    
    @IBAction func showPasswordAction(_ sender: Any) {
        self.passwordTextField.isSecureTextEntry.toggle()
        if self.passwordTextField.isSecureTextEntry {
            self.showPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            self.showPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue).withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @IBAction func showConfirmPasswordAction(_ sender: Any) {
        self.confirmPasswordTextField.isSecureTextEntry.toggle()
        if self.confirmPasswordTextField.isSecureTextEntry {
            self.showConfirmPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            self.showConfirmPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue).withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
}
