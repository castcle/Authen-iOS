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
//  SignInTableViewCell.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 8/4/2565 BE.
//

import UIKit
import Core
import ActiveLabel
import JGProgressHUD
import Defaults

protocol SignInTableViewCellDelegate {
    func didLoginWithFacebook(_ signInTableViewCell: SignInTableViewCell)
    func didLoginWithTwitter(_ signInTableViewCell: SignInTableViewCell)
    func didLoginWithGoogle(_ signInTableViewCell: SignInTableViewCell)
    func didLoginWithApple(_ signInTableViewCell: SignInTableViewCell)
}

class SignInTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var loginSocialLabel: UILabel!
    @IBOutlet var signInLabel: ActiveLabel!
    @IBOutlet var emailView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var showPasswordButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var firstLineView: UIView!
    @IBOutlet var seccondLineView: UIView!
    @IBOutlet var facebookView: UIView!
    @IBOutlet var twitterView: UIView!
    @IBOutlet var googleView: UIView!
    @IBOutlet var appleView: UIView!
    @IBOutlet var facebookImage: UIImageView!
    @IBOutlet var twitterImage: UIImageView!
    @IBOutlet var googleImage: UIImageView!
    @IBOutlet var appleImage: UIImageView!
    
    public var delegate: SignInTableViewCellDelegate?
    let hud = JGProgressHUD()
    var viewModel = LoginViewModel()
    private var isCanLogin: Bool {
        if self.emailTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hud.textLabel.text = "Logging in"
        self.headlineLabel.font = UIFont.asset(.bold, fontSize: .h2)
        self.headlineLabel.textColor = UIColor.Asset.lightBlue
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.emailLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.emailLabel.textColor = UIColor.Asset.white
        self.passwordLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.passwordLabel.textColor = UIColor.Asset.white
        self.loginSocialLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.loginSocialLabel.textColor = UIColor.Asset.lightBlue
        self.emailView.capsule(color: UIColor.Asset.darkGray)
        self.passwordView.capsule(color: UIColor.Asset.darkGray)
        self.forgotPasswordButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.forgotPasswordButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.showPasswordButton.setImage(UIImage.init(icon: .castcle(.show), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.emailTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.emailTextField.textColor = UIColor.Asset.white
        self.passwordTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.passwordTextField.textColor = UIColor.Asset.white
        self.passwordTextField.isSecureTextEntry = true
        self.firstLineView.backgroundColor = UIColor.Asset.lightBlue
        self.seccondLineView.backgroundColor = UIColor.Asset.lightBlue
        self.facebookView.capsule(color: UIColor.Asset.facebook)
        self.twitterView.capsule(color: UIColor.Asset.twitter)
        self.googleView.capsule(color: UIColor.Asset.white)
        self.appleView.capsule(color: UIColor.Asset.apple)
        self.facebookImage.image = UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.twitterImage.image = UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.googleImage.image = UIImage.Asset.googleLogo
        self.appleImage.image = UIImage.init(icon: .castcle(.apple), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        
        self.signInLabel.customize { label in
            label.font = UIFont.asset(.regular, fontSize: .body)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.white
            let signUpType = ActiveType.custom(pattern: Localization.login.signUp.text)
            label.enabledTypes = [signUpType]
            label.customColor[signUpType] = UIColor.Asset.lightBlue
            label.customSelectedColor[signUpType] = UIColor.Asset.lightBlue
            label.handleCustomTap(for: signUpType) { element in
                self.endEditing(true)
//                Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.email(fromSignIn: true)), animated: true)
            }
        }
        
        self.setupLoginButton(isActive: self.isCanLogin)
        
        self.emailTextField.delegate = self
        self.emailTextField.tag = 0
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.passwordTextField.delegate = self
        self.passwordTextField.tag = 1
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.viewModel.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func disableUI(isActive: Bool) {
        if isActive {
            self.emailTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
        } else {
            self.emailTextField.isEnabled = false
            self.passwordTextField.isEnabled = false
        }
    }
    
    private func setupLoginButton(isActive: Bool) {
        self.loginButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        if isActive {
            self.loginButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.loginButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        } else {
            self.loginButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.loginButton.capsule(color: UIColor.Asset.darkGraphiteBlue, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.setupLoginButton(isActive: self.isCanLogin)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.passwordTextField.becomeFirstResponder()
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
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        self.endEditing(true)
//        Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.checkEmail), animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if self.isCanLogin {
            self.endEditing(true)
            self.disableUI(isActive: false)
            self.hud.show(in: Utility.currentViewController().view)
            self.viewModel.loginRequest.username = self.emailTextField.text ?? ""
            self.viewModel.loginRequest.password = self.passwordTextField.text ?? ""
            self.viewModel.login()
        }
    }
    
    @IBAction func facebookAction(_ sender: Any) {
        self.delegate?.didLoginWithFacebook(self)
    }
    
    @IBAction func twitterAction(_ sender: Any) {
        self.delegate?.didLoginWithTwitter(self)
    }
    
    @IBAction func googleAction(_ sender: Any) {
        self.delegate?.didLoginWithGoogle(self)
    }
    
    @IBAction func appleAction(_ sender: Any) {
        self.delegate?.didLoginWithApple(self)
    }
}

extension SignInTableViewCell: LoginViewModelDelegate {
    func didLoginFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            Defaults[.startLoadFeed] = true
            Utility.currentViewController().dismiss(animated: true)
        } else {
            self.disableUI(isActive: true)
        }
    }
}
