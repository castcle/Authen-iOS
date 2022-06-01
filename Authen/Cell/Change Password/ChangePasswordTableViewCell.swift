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
//  Created by Castcle Co., Ltd. on 30/8/2564 BE.
//

import UIKit
import Core
import JVFloatLabeledTextField
import JGProgressHUD

class ChangePasswordTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var limitCharLabel: UILabel!
    @IBOutlet var typeCharLabel: UILabel!
    @IBOutlet var passwordNotMatchLabel: UILabel!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var confirmPasswordLabel: UILabel!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var confirmPasswordView: UIView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var showPasswordButton: UIButton!
    @IBOutlet var showConfirmPasswordButton: UIButton!
    @IBOutlet var charCountImage: UIImageView!
    @IBOutlet var charTypeImage: UIImageView!
    @IBOutlet var passwordNotMatchImage: UIImageView!

    private var viewModel = ChangePasswordViewModel(.changePassword)
    let hud = JGProgressHUD()

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
        self.setupContinueButton(isActive: self.isCanContinue)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .head2)
        self.headlineLabel.textColor = UIColor.Asset.white
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
        self.passwordLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.passwordLabel.textColor = UIColor.Asset.white
        self.confirmPasswordLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.confirmPasswordLabel.textColor = UIColor.Asset.white
        self.passwordView.capsule(color: UIColor.Asset.darkGray)
        self.confirmPasswordView.capsule(color: UIColor.Asset.darkGray)
        self.passwordTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.passwordTextField.textColor = UIColor.Asset.white
        self.passwordTextField.isSecureTextEntry = true
        self.confirmPasswordTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.confirmPasswordTextField.textColor = UIColor.Asset.white
        self.confirmPasswordTextField.isSecureTextEntry = true
        self.passwordTextField.delegate = self
        self.passwordTextField.tag = 0
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.confirmPasswordTextField.delegate = self
        self.confirmPasswordTextField.tag = 1
        self.confirmPasswordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(viewModel: ChangePasswordViewModel) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
        self.hud.textLabel.text = "Creating"
    }

    private func setupContinueButton(isActive: Bool) {
        self.applyButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
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

    private func checkPasswordNotMatch() {
        if self.passwordTextField.text! == self.confirmPasswordTextField.text! {
            self.passwordNotMatchLabel.textColor = UIColor.Asset.lightBlue
            self.passwordNotMatchImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
        } else {
            self.passwordNotMatchLabel.textColor = UIColor.Asset.gray
            self.passwordNotMatchImage.image = UIImage.init(icon: .castcle(.addWithCheckmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.gray)
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        self.setupContinueButton(isActive: self.isCanContinue)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.confirmPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
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

    @IBAction func applyAction(_ sender: Any) {
        self.endEditing(true)
        if self.isCanContinue {
            self.hud.show(in: Utility.currentViewController().view)
            self.applyButton.isEnabled = false
            self.viewModel.authenRequest.newPassword = self.passwordTextField.text ?? ""
            self.viewModel.changePassword()
        }
    }
}

extension ChangePasswordTableViewCell: ChangePasswordViewModelDelegate {
    func didChangePasswordSubmitFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            if self.viewModel.changePasswordType == .createPassword {
                let viewControllers: [UIViewController] = Utility.currentViewController().navigationController!.viewControllers as [UIViewController]
                Utility.currentViewController().navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            } else {
                Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.changePasswordSuccess(self.viewModel)), animated: true)
            }
        } else {
            self.applyButton.isEnabled = true
        }
    }
}
