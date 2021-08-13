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
//  SignInCell.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 30/7/2564 BE.
//

import UIKit
import Core
import ActiveLabel
import SwiftColor
import JVFloatLabeledTextField

class SignInCell: UICollectionViewCell {

    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var showPasswordButton: UIButton!
    
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
    
    @IBOutlet var welcomeLabel: ActiveLabel! {
        didSet {
            self.welcomeLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .h2)
                label.numberOfLines = 1
                label.textColor = UIColor.Asset.white
                
                let castcleType = ActiveType.custom(pattern: "Castcle")
                
                label.enabledTypes = [castcleType]
                label.customColor[castcleType] = UIColor.Asset.lightBlue
                label.customSelectedColor[castcleType] = UIColor.Asset.lightBlue
            }
        }
    }
    @IBOutlet var signInLabel: ActiveLabel! {
        didSet {
            self.signInLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .h4)
                label.numberOfLines = 1
                label.textColor = UIColor.Asset.white
                
                let signUpType = ActiveType.custom(pattern: "sign up")
                
                label.enabledTypes = [signUpType]
                label.customColor[signUpType] = UIColor.Asset.lightBlue
                label.customSelectedColor[signUpType] = UIColor.Asset.lightBlue
                
                label.handleCustomTap(for: signUpType) { element in
                    self.endEditing(true)
                    Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.email), animated: true)
                }
            }
        }
    }
    
    private var isCanLogin: Bool {
        if self.emailTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.logoImage.image = UIImage.Asset.castcleLogo
        self.emailView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.passwordView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.forgotPasswordButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.forgotPasswordButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.showPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.setupLoginButton(isActive: self.isCanLogin)
        
        self.emailTextField.tag = 0
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.passwordTextField.tag = 1
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupLoginButton(isActive: Bool) {
        self.loginButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        
        if isActive {
            self.loginButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.loginButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.loginButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.loginButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.loginButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.loginButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }
    
    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 620)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.setupLoginButton(isActive: self.isCanLogin)
    }
    
    @IBAction func showPasswordAction(_ sender: Any) {
        self.passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        self.endEditing(true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if self.isCanLogin {
            self.endEditing(true)
            UserState.shared.login()
            Utility.currentViewController().navigationController?.popToRootViewController(animated: true)
        }
    }
}
