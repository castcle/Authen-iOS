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
//  CreatePasswordCell.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 2/8/2564 BE.
//

import UIKit
import Core
import JVFloatLabeledTextField

class CreatePasswordCell: UICollectionViewCell, UITextFieldDelegate {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var alertLabel: UILabel!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var confirmPasswordView: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var showPasswordButton: UIButton!
    @IBOutlet var showConfirmPasswordButton: UIButton!
    @IBOutlet var passwordTextField: JVFloatLabeledTextField!
    @IBOutlet var confirmPasswordTextField: JVFloatLabeledTextField!
    
    var viewModel = CreatePasswordViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.passwordView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.confirmPasswordView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.welcomeLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.welcomeLabel.textColor = UIColor.Asset.white
        self.alertLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.alertLabel.textColor = UIColor.Asset.white
        self.showPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.showConfirmPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.setupNextButton(isActive: false)
        
        self.passwordTextField.delegate = self
        self.passwordTextField.tag = 0
        self.confirmPasswordTextField.delegate = self
        self.confirmPasswordTextField.tag = 1
    }
    
    func configCell() {
        self.headlineLabel.text = Localization.RegisterPassword.headline.text
        self.welcomeLabel.text = Localization.RegisterPassword.subtitle.text
        self.alertLabel.text = Localization.RegisterPassword.notice.text
        self.nextButton.setTitle(Localization.RegisterPassword.button.text, for: .normal)
        self.passwordTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.passwordTextField.placeholder = Localization.RegisterPassword.value.text
        self.passwordTextField.placeholderColor = UIColor.Asset.gray
        self.passwordTextField.floatingLabelTextColor = UIColor.Asset.gray
        self.passwordTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
        self.passwordTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
        self.passwordTextField.textColor = UIColor.Asset.white
        self.passwordTextField.isSecureTextEntry = true
        self.confirmPasswordTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.confirmPasswordTextField.placeholder = Localization.RegisterPassword.retry.text
        self.confirmPasswordTextField.placeholderColor = UIColor.Asset.gray
        self.confirmPasswordTextField.floatingLabelTextColor = UIColor.Asset.gray
        self.confirmPasswordTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
        self.confirmPasswordTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
        self.confirmPasswordTextField.textColor = UIColor.Asset.white
        self.confirmPasswordTextField.isSecureTextEntry = true
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
    
    private func validatePassword() -> Bool {
        if self.passwordTextField.text!.isPassword {
            if self.passwordTextField.text == self.confirmPasswordTextField.text {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 500)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.alertLabel.textColor = UIColor.Asset.white
        self.alertLabel.text = Localization.RegisterPassword.notice.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !self.passwordTextField.text!.isPassword {
            self.alertLabel.textColor = UIColor.Asset.denger
            self.alertLabel.text = "Wrong password format.\n\n\(Localization.RegisterPassword.notice.text)"
        } else if self.passwordTextField.text! != self.confirmPasswordTextField.text! {
            self.alertLabel.textColor = UIColor.Asset.denger
            self.alertLabel.text = "Password and confirm password not match"
        } else {
            self.alertLabel.textColor = UIColor.Asset.white
            self.alertLabel.text = Localization.RegisterPassword.notice.text
        }
        
        if self.validatePassword() {
            self.setupNextButton(isActive: true)
        } else {
            self.setupNextButton(isActive: false)
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
    
    @IBAction func nextAction(_ sender: Any) {
        self.endEditing(true)
        if self.validatePassword() {
            self.viewModel.authenRequest.payload.password = self.passwordTextField.text!
            let vc = AuthenOpener.open(.createDisplayName) as? CreateDisplayNameViewController
            vc?.viewModel = CreateDisplayNameViewModel(authenRequest: self.viewModel.authenRequest)
            Utility.currentViewController().navigationController?.pushViewController(vc ?? CreateDisplayNameViewController(), animated: true)
        }
    }
}
