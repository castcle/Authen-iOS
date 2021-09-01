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
//  CheckEmailViewController.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 31/8/2564 BE.
//

import UIKit
import Core
import JVFloatLabeledTextField

class CheckEmailViewController: UIViewController {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var emailView: UIView!
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
    @IBOutlet var searchButton: UIButton!
    
    private var isCanContinue: Bool {
        if self.emailTextField.text!.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.setupNavBar()
        self.emailView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.setupContinueButton(isActive: self.isCanContinue)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .h2)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.detailLabel.textColor = UIColor.Asset.white

        self.emailTextField.tag = 0
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "ค้นหาบัญชี")
    }
    
    private func setupContinueButton(isActive: Bool) {
        self.searchButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        
        if isActive {
            self.searchButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.searchButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.searchButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.searchButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.searchButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.searchButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.setupContinueButton(isActive: self.isCanContinue)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        self.view.endEditing(true)
        if self.isCanContinue {
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.forgotPassword), animated: true)
        }
    }
}
