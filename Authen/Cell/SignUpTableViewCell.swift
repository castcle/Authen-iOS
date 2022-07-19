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
import Component
import ActiveLabel

class SignUpTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var subtitleSignUpLabel: UILabel!
    @IBOutlet var emailSignUpLabel: UILabel!
    @IBOutlet var passwordSignUpLabel: UILabel!
    @IBOutlet var confirmPasswordSignUpLabel: UILabel!
    @IBOutlet var emailSignUpView: UIView!
    @IBOutlet var passwordSignUpView: UIView!
    @IBOutlet var confirmPasswordSignUpView: UIView!
    @IBOutlet var emailSignUpTextField: UITextField!
    @IBOutlet var passwordSignUpTextField: UITextField!
    @IBOutlet var confirmPasswordSignUpTextField: UITextField!
    @IBOutlet var emailAlertSignUpLabel: UILabel!
    @IBOutlet var limitCharSignUpLabel: UILabel!
    @IBOutlet var typeCharSignUpLabel: UILabel!
    @IBOutlet var passwordNotMatchSignUpLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var showPasswordSignUpButton: UIButton!
    @IBOutlet var showConfirmPasswordSignUpButton: UIButton!
    @IBOutlet var charCountSignUpImage: UIImageView!
    @IBOutlet var charTypeSignUpImage: UIImageView!
    @IBOutlet var passwordNotMatchSignUpImage: UIImageView!
    @IBOutlet var termSignUpLabel: ActiveLabel!
    @IBOutlet var signLabel: ActiveLabel!
    @IBOutlet var agreeSignUpView: UIView!
    @IBOutlet var agreeSignUpIcon: UIImageView!

    var viewModel = SignUpViewModel()

    private var isPasswordValid: Bool {
        self.checkCharacterSignUpCount()
        self.checkCharacterSignUpType()
        self.checkPasswordSignUpNotMatch()
        if self.passwordSignUpTextField.text!.isEmpty || self.confirmPasswordSignUpTextField.text!.isEmpty {
            return false
        } else if self.passwordSignUpTextField.text!.count < 6 || self.passwordSignUpTextField.text!.count > 250 {
            return false
        } else if !self.passwordSignUpTextField.text!.isPassword {
            return false
        } else if self.passwordSignUpTextField.text != self.confirmPasswordSignUpTextField.text {
            return false
        } else {
            return true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subtitleSignUpLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.subtitleSignUpLabel.textColor = UIColor.Asset.white
        self.emailSignUpLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.emailSignUpLabel.textColor = UIColor.Asset.white
        self.passwordSignUpLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.passwordSignUpLabel.textColor = UIColor.Asset.white
        self.confirmPasswordSignUpLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.confirmPasswordSignUpLabel.textColor = UIColor.Asset.white
        self.emailSignUpTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.emailSignUpTextField.textColor = UIColor.Asset.white
        self.passwordSignUpTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.passwordSignUpTextField.textColor = UIColor.Asset.white
        self.passwordSignUpTextField.isSecureTextEntry = true
        self.confirmPasswordSignUpTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.confirmPasswordSignUpTextField.textColor = UIColor.Asset.white
        self.confirmPasswordSignUpTextField.isSecureTextEntry = true
        self.emailSignUpView.capsule(color: UIColor.Asset.cellBackground)
        self.passwordSignUpView.capsule(color: UIColor.Asset.cellBackground)
        self.confirmPasswordSignUpView.capsule(color: UIColor.Asset.cellBackground)
        self.emailSignUpTextField.tag = 0
        self.emailSignUpTextField.delegate = self
        self.emailSignUpTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.passwordSignUpTextField.delegate = self
        self.passwordSignUpTextField.tag = 1
        self.passwordSignUpTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.confirmPasswordSignUpTextField.delegate = self
        self.confirmPasswordSignUpTextField.tag = 2
        self.confirmPasswordSignUpTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.emailAlertSignUpLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.emailAlertSignUpLabel.textColor = UIColor.Asset.white
        self.emailAlertSignUpLabel.isHidden = true
        self.limitCharSignUpLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.limitCharSignUpLabel.textColor = UIColor.Asset.gray
        self.typeCharSignUpLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.typeCharSignUpLabel.textColor = UIColor.Asset.gray
        self.passwordNotMatchSignUpLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.passwordNotMatchSignUpLabel.textColor = UIColor.Asset.gray
        self.showPasswordSignUpButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.showConfirmPasswordSignUpButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.charCountSignUpImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        self.charTypeSignUpImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        self.passwordNotMatchSignUpImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        self.agreeSignUpView.custom(color: UIColor.Asset.white, cornerRadius: 2.0)
        self.setupContinueButton(isPasswordValid: false)
        self.setupAgreeView()

        self.signLabel.customize { label in
            label.font = UIFont.asset(.regular, fontSize: .body)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.white
            let signInType = ActiveType.custom(pattern: "Log in")
            label.enabledTypes = [signInType]
            label.customColor[signInType] = UIColor.Asset.lightBlue
            label.customSelectedColor[signInType] = UIColor.Asset.lightGray
            label.handleCustomTap(for: signInType) { _ in
                self.endEditing(true)
                Utility.currentViewController().navigationController?.popViewController(animated: true)
            }
        }

        self.termSignUpLabel.customize { label in
            label.font = UIFont.asset(.regular, fontSize: .overline)
            label.numberOfLines = 0
            label.textColor = UIColor.Asset.white
            let termType = ActiveType.custom(pattern: "Castcle Terms and Agreement")
            let policyType = ActiveType.custom(pattern: "Privacy Policy")
            label.enabledTypes = [termType, policyType]
            label.customColor[termType] = UIColor.Asset.lightBlue
            label.customColor[policyType] = UIColor.Asset.lightBlue
            label.customSelectedColor[termType] = UIColor.Asset.lightGray
            label.customSelectedColor[policyType] = UIColor.Asset.lightGray
            label.handleCustomTap(for: termType) { _ in
                self.endEditing(true)
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: Environment.userAgreement)!)), animated: true)
            }
            label.handleCustomTap(for: policyType) { _ in
                self.endEditing(true)
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: Environment.privacyPolicy)!)), animated: true)
            }
        }

        self.viewModel.didCheckEmailExistsFinish = {
            self.emailSignUpTextField.isEnabled = true
            self.setupContinueButton(isPasswordValid: self.isPasswordValid)
            if self.viewModel.isEmailExist {
                self.emailAlertSignUpLabel.isHidden = false
                self.emailAlertSignUpLabel.text  = Localization.RegisterCheckEmail.alertEmailInvalid.text
                self.emailAlertSignUpLabel.textColor = UIColor.Asset.denger
            } else {
                self.emailAlertSignUpLabel.isHidden = false
                self.emailAlertSignUpLabel.text  = Localization.RegisterCheckEmail.alertEmailValid.text
                self.emailAlertSignUpLabel.textColor = UIColor.Asset.lightBlue
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.passwordSignUpTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            self.confirmPasswordSignUpTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            let email: String = textField.text ?? ""
            if email.isEmpty {
                self.emailAlertSignUpLabel.isHidden = true
                self.emailAlertSignUpLabel.text  = Localization.RegisterCheckEmail.alertNotice.text
                self.emailAlertSignUpLabel.textColor = UIColor.Asset.white
            } else if email.isEmail {
                textField.isEnabled = false
                self.viewModel.authenRequest.email = email
                self.viewModel.checkEmailExists()
            } else {
                self.emailAlertSignUpLabel.isHidden = false
                self.emailAlertSignUpLabel.text  = Localization.RegisterCheckEmail.alertWrongFormat.text
                self.emailAlertSignUpLabel.textColor = UIColor.Asset.denger
            }
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let textValue = textField.text ?? ""
        textField.text = textValue.substringWithRange(range: 250)
        if textField.tag == 0 {
            self.emailAlertSignUpLabel.isHidden = true
        } else {
            self.setupContinueButton(isPasswordValid: self.isPasswordValid)
        }
    }

    private func setupContinueButton(isPasswordValid: Bool) {
        self.nextButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        if isPasswordValid && !self.viewModel.isEmailExist && self.viewModel.isAgree {
            self.nextButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.nextButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }

    private func setupAgreeView() {
        if self.viewModel.isAgree {
            self.agreeSignUpIcon.image = UIImage.init(icon: .castcle(.checkmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
        } else {
            self.agreeSignUpIcon.image = UIImage()
        }
    }

    private func checkCharacterSignUpCount() {
        if self.passwordSignUpTextField.text!.count < 6 || self.passwordSignUpTextField.text!.count > 20 {
            self.limitCharSignUpLabel.textColor = UIColor.Asset.gray
            self.charCountSignUpImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        } else {
            self.limitCharSignUpLabel.textColor = UIColor.Asset.lightBlue
            self.charCountSignUpImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
        }
    }

    private func checkCharacterSignUpType() {
        if self.passwordSignUpTextField.text!.isMatchChar {
            self.typeCharSignUpLabel.textColor = UIColor.Asset.lightBlue
            self.charTypeSignUpImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
        } else {
            self.typeCharSignUpLabel.textColor = UIColor.Asset.gray
            self.charTypeSignUpImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        }
    }

    private func checkPasswordSignUpNotMatch() {
        if !(self.confirmPasswordSignUpTextField.text!.isEmpty) && (self.passwordSignUpTextField.text! == self.confirmPasswordSignUpTextField.text!) {
            self.passwordNotMatchSignUpLabel.textColor = UIColor.Asset.lightBlue
            self.passwordNotMatchSignUpImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
        } else {
            self.passwordNotMatchSignUpLabel.textColor = UIColor.Asset.gray
            self.passwordNotMatchSignUpImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        }
    }

    @IBAction func showPasswordSignUpAction(_ sender: Any) {
        self.passwordSignUpTextField.isSecureTextEntry.toggle()
        if self.passwordSignUpTextField.isSecureTextEntry {
            self.showPasswordSignUpButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            self.showPasswordSignUpButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue).withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }

    @IBAction func showConfirmPasswordSignUpAction(_ sender: Any) {
        self.confirmPasswordSignUpTextField.isSecureTextEntry.toggle()
        if self.confirmPasswordSignUpTextField.isSecureTextEntry {
            self.showConfirmPasswordSignUpButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            self.showConfirmPasswordSignUpButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue).withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }

    @IBAction func agreeSignUpAction(_ sender: Any) {
        self.viewModel.isAgree.toggle()
        self.setupContinueButton(isPasswordValid: self.isPasswordValid)
        self.setupAgreeView()
    }

    @IBAction func nextAction(_ sender: Any) {
        self.endEditing(true)
        if self.isPasswordValid && !self.viewModel.isEmailExist && self.viewModel.isAgree {
            Utility.currentViewController().navigationController?.setNavigationBarHidden(false, animated: true)
            self.viewModel.authenRequest.password = self.passwordSignUpTextField.text!
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.createDisplayName(CreateDisplayNameViewModel(authenRequest: self.viewModel.authenRequest))), animated: true)
        }
    }
}
