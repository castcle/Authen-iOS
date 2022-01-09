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
//  EmailCell.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 2/8/2564 BE.
//

import UIKit
import Core
import JVFloatLabeledTextField

class EmailCell: UICollectionViewCell, UITextFieldDelegate {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var alertLabel: UILabel!
    @IBOutlet var emailView: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var emailTextField: JVFloatLabeledTextField!
    @IBOutlet var statusButton: UIButton!
    
    var viewModel = EmailViewModel()
    
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
        self.activityIndicator.color = UIColor.Asset.lightBlue
        self.activityIndicator.isHidden = true
        self.setupNextButton(isActive: false)
        
        self.checkImage.isHidden = true
        self.checkImage.tintColor = UIColor.Asset.denger
        self.emailTextField.delegate = self
        
        self.viewModel.didCheckEmailExistsFinish = {
            self.emailTextField.isEnabled = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            if self.viewModel.isEmailExist {
                self.setupNextButton(isActive: false)
                self.checkImage.isHidden = false
                self.checkImage.image = UIImage.init(icon: .castcle(.incorrect), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.denger)
                self.alertLabel.text  = Localization.registerCheckEmail.alertEmailInvalid.text
                self.alertLabel.textColor = UIColor.Asset.denger
                self.emailTextField.textColor = UIColor.Asset.denger
            } else {
                self.setupNextButton(isActive: true)
                self.checkImage.isHidden = false
                self.checkImage.image = UIImage.init(icon: .castcle(.checkmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
                self.alertLabel.text  = Localization.registerCheckEmail.alertEmailValid.text
                self.alertLabel.textColor = UIColor.Asset.lightBlue
                self.emailTextField.textColor = UIColor.Asset.white
            }
        }
    }
    
    func configCell(fromSignIn: Bool) {
        self.viewModel.framSignIn = fromSignIn
        self.headlineLabel.text = Localization.registerCheckEmail.headline.text
        self.welcomeLabel.text = Localization.registerCheckEmail.welcome.text
        self.alertLabel.text = Localization.registerCheckEmail.alertNotice.text
        self.nextButton.setTitle(Localization.registerCheckEmail.button.text, for: .normal)
        self.loginButton.setTitle(Localization.registerCheckEmail.alreadyAccount.text, for: .normal)
        self.emailTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.emailTextField.placeholder = Localization.registerCheckEmail.email.text
        self.emailTextField.placeholderColor = UIColor.Asset.gray
        self.emailTextField.floatingLabelTextColor = UIColor.Asset.gray
        self.emailTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
        self.emailTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
        self.emailTextField.textColor = UIColor.Asset.white
    }
    
    private func setupNextButton(isActive: Bool) {
        self.nextButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        
        if isActive {
            self.statusButton.isEnabled = false
            self.nextButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.statusButton.isEnabled = true
            self.nextButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }
    
    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 500)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setupNextButton(isActive: false)
        self.checkImage.isHidden = true
        self.alertLabel.text  = Localization.registerCheckEmail.alertNotice.text
        self.alertLabel.textColor = UIColor.Asset.white
        self.emailTextField.textColor = UIColor.Asset.white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let email: String = textField.text ?? ""
        if email.isEmpty {
            self.setupNextButton(isActive: false)
            self.checkImage.isHidden = true
            self.alertLabel.text  = Localization.registerCheckEmail.alertNotice.text
            self.alertLabel.textColor = UIColor.Asset.white
            self.emailTextField.textColor = UIColor.Asset.white
        } else if email.isEmail {
            textField.isEnabled = false
            self.activityIndicator.isHidden = false
            self.checkImage.isHidden = true
            self.activityIndicator.startAnimating()
            self.viewModel.authenRequest.payload.email = textField.text!
            self.viewModel.checkEmailExists()
        } else {
            self.setupNextButton(isActive: false)
            self.checkImage.isHidden = false
            self.checkImage.image = UIImage.init(icon: .castcle(.incorrect), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.denger)
            self.alertLabel.text  = Localization.registerCheckEmail.alertWrongFormat.text
            self.alertLabel.textColor = UIColor.Asset.denger
            self.emailTextField.textColor = UIColor.Asset.denger
        }
    }
    
    @IBAction func statusAction(_ sender: Any) {
        self.emailTextField.text = ""
        self.checkImage.isHidden = true
        self.alertLabel.text  = Localization.registerCheckEmail.alertNotice.text
        self.alertLabel.textColor = UIColor.Asset.white
        self.emailTextField.textColor = UIColor.Asset.white
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if !self.viewModel.isEmailExist {
            self.endEditing(true)
            let vc = AuthenOpener.open(.createPassword) as? CreatePasswordViewController
            vc?.viewModel = CreatePasswordViewModel(authenRequest: self.viewModel.authenRequest)
            Utility.currentViewController().navigationController?.pushViewController(vc ?? CreatePasswordViewController(), animated: true)
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.endEditing(true)
        if self.viewModel.framSignIn {
            Utility.currentViewController().navigationController?.popViewController(animated: true)
        } else {
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.signIn(showSignUp: false)), animated: true)
        }
    }
}
