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
//  OldPasswordTableViewCell.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 30/8/2564 BE.
//

import UIKit
import Core
import Component
import JVFloatLabeledTextField

class OldPasswordTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var showPasswordButton: UIButton!
    @IBOutlet var applyButton: UIButton!

    var viewModel: VerifyPasswordViewModel = VerifyPasswordViewModel()
    private var isCanContinue: Bool {
        if self.passwordTextField.text!.isEmpty {
            return false
        } else {
            return true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.passwordView.capsule(color: UIColor.Asset.cellBackground)
        self.applyButton.activeButton(isActive: self.isCanContinue)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .head2)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.detailLabel.font = UIFont.asset(.light, fontSize: .body)
        self.detailLabel.textColor = UIColor.Asset.white
        self.passwordLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.passwordLabel.textColor = UIColor.Asset.white
        self.showPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.delegate = self
        self.passwordTextField.tag = 0
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.viewModel.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        self.applyButton.activeButton(isActive: self.isCanContinue)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func applyAction(_ sender: Any) {
        self.endEditing(true)
        if self.isCanContinue {
            CCLoading.shared.show(text: "Checking")
            self.applyButton.isEnabled = false
            self.viewModel.authenRequest.email = UserManager.shared.email
            self.viewModel.authenRequest.password = self.passwordTextField.text ?? ""
            self.viewModel.verifyPassword()
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
}

extension OldPasswordTableViewCell: VerifyPasswordViewModelDelegate {
    func didVerificationPasswordFinish(success: Bool) {
        CCLoading.shared.dismiss()
        if success {
            self.viewModel.authenRequest.objective = .changePassword
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.changePassword(ChangePasswordViewModel(.changePassword, authenRequest: self.viewModel.authenRequest))), animated: true)
        } else {
            self.applyButton.isEnabled = true
        }
    }
}
