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
//  ChangePasswordTableViewCell.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 30/8/2564 BE.
//

import UIKit
import Core
import JVFloatLabeledTextField

class ChangePasswordTableViewCell: UITableViewCell {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var passwordGuideLabel: UILabel!
    @IBOutlet var limitCharLabel: UILabel!
    @IBOutlet var typeCharLabel: UILabel!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var confirmPasswordView: UIView!
    @IBOutlet var passwordTextField: JVFloatLabeledTextField! {
        didSet {
            self.passwordTextField.font = UIFont.asset(.regular, fontSize: .body)
            self.passwordTextField.placeholder = "Password"
            self.passwordTextField.placeholderColor = UIColor.Asset.gray
            self.passwordTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.passwordTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.passwordTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.passwordTextField.textColor = UIColor.Asset.white
            self.passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet var confirmPasswordTextField: JVFloatLabeledTextField! {
        didSet {
            self.confirmPasswordTextField.font = UIFont.asset(.regular, fontSize: .body)
            self.confirmPasswordTextField.placeholder = "Confirm Password"
            self.confirmPasswordTextField.placeholderColor = UIColor.Asset.gray
            self.confirmPasswordTextField.floatingLabelTextColor = UIColor.Asset.gray
            self.confirmPasswordTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
            self.confirmPasswordTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
            self.confirmPasswordTextField.textColor = UIColor.Asset.white
            self.confirmPasswordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet var charCountImage: UIImageView!
    @IBOutlet var charTypeImage: UIImageView!
    
    var viewModel = ChangePasswordViewModel(.changePassword)
    
    private var isCanContinue: Bool {
        self.checkCharacterCount()
        self.checkCharacterType()
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
        self.passwordView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.confirmPasswordView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.setupContinueButton(isActive: self.isCanContinue)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .h2)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.passwordGuideLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.passwordGuideLabel.textColor = UIColor.Asset.white
        self.limitCharLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.limitCharLabel.textColor = UIColor.Asset.gray
        self.typeCharLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.typeCharLabel.textColor = UIColor.Asset.gray
        self.charCountImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        self.charTypeImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)

        self.passwordTextField.tag = 0
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.confirmPasswordTextField.tag = 1
        self.confirmPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(viewModel: ChangePasswordViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupContinueButton(isActive: Bool) {
        self.applyButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        
        if isActive {
            self.applyButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.applyButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.applyButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.applyButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.applyButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.applyButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.setupContinueButton(isActive: self.isCanContinue)
    }
    
    @IBAction func applyAction(_ sender: Any) {
        self.endEditing(true)
        if self.isCanContinue {
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.changePasswordSuccess(self.viewModel)), animated: true)
        }
    }
}
