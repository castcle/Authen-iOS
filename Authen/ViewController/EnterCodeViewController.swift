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
//  EnterCodeViewController.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 31/8/2564 BE.
//

import UIKit
import Core
import SVPinView
import Defaults

class EnterCodeViewController: UIViewController {

    @IBOutlet var pinView: SVPinView!
    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var noticLabel: UILabel!
    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var resendButton: UIButton!
    
    var secondsRemaining = 60
    var viewModel = EnterCodeViewModel(verifyCodeType: .password)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .h2)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.detailLabel.textColor = UIColor.Asset.white
        self.noticLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.noticLabel.textColor = UIColor.Asset.white
        self.countdownLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.countdownLabel.textColor = UIColor.Asset.lightGray
        self.resendButton.titleLabel?.font = UIFont.asset(.medium, fontSize: .body)
        self.resendButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        
        self.pinView.backgroundColor = UIColor.clear
        self.pinView.pinLength = 6
        self.pinView.style = .underline
        self.pinView.interSpace = 20
        self.pinView.shouldSecureText = false
        self.pinView.fieldBackgroundColor = UIColor.clear
        self.pinView.textColor = UIColor.Asset.white
        self.pinView.borderLineColor = UIColor.Asset.white
        self.pinView.activeBorderLineColor = UIColor.Asset.white
        self.pinView.borderLineThickness = 1
        self.pinView.activeBorderLineThickness = 1
        self.pinView.font = UIFont.asset(.medium, fontSize: .h2)
        self.pinView.keyboardType = .numberPad
        
        self.pinView.didFinishCallback = { [weak self] pin in
            guard let self = self else { return }
            if self.viewModel.verifyCodeType == .password {
                self.gotoCreatePassword()
            } else if self.viewModel.verifyCodeType == .mergeAccount {
                self.gotoFeed()
            }
            print("The pin entered is \(pin)")
        }
        
        self.countdownLabel.text = "Resend Code \(self.secondsRemaining)s"
        self.setupCountdown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "")
    }
    
    private func gotoCreatePassword() {
        Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.changePassword(ChangePasswordViewModel(.forgotPassword))), animated: true)
    }
    
    private func gotoFeed() {
        Utility.currentViewController().navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupCountdown() {
        self.countdownLabel.isHidden = false
        self.resendButton.isHidden = true
        self.secondsRemaining = 60
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsRemaining > 0 {
                self.countdownLabel.text = "Resend Code \(self.secondsRemaining)s"
                self.secondsRemaining -= 1
            } else {
                Timer.invalidate()
                self.countdownLabel.isHidden = true
                self.resendButton.isHidden = false
            }
        }
    }
    
    @IBAction func resendAction(_ sender: Any) {
        self.setupCountdown()
    }
}
