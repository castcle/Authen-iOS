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
//  Created by Castcle Co., Ltd. on 31/8/2564 BE.
//

import UIKit
import Core
import SVPinView
import Defaults
import JGProgressHUD

class EnterCodeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = EnterCodeViewModel(verifyCodeType: .password)
    let hud = JGProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.configureTableView()
        self.setupNavBar()
        self.viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "")
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: AuthenNibVars.TableViewCell.verifyEmailOtp, bundle: ConfigBundle.authen), forCellReuseIdentifier: AuthenNibVars.TableViewCell.verifyEmailOtp)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    private func gotoCreatePassword() {
        self.viewModel.authenRequest.payload.objective = .forgotPassword
        Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.changePassword(ChangePasswordViewModel(.forgotPassword, authenRequest: self.viewModel.authenRequest))), animated: true)
    }

    private func gotoMergeSuccess() {
        Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.mergeAccountSuccess), animated: true)
    }
}

extension EnterCodeViewController: EnterCodeViewModelDelegate {
    func didVerifyOtpFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            if self.viewModel.verifyCodeType == .password {
                self.gotoCreatePassword()
            } else if self.viewModel.verifyCodeType == .mergeAccount {
                self.gotoMergeSuccess()
            }
        }
    }

    func didRequestOtpFinish(success: Bool) {
        self.hud.dismiss()
    }

    func didError() {
        self.hud.dismiss()
    }
}

extension EnterCodeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AuthenNibVars.TableViewCell.verifyEmailOtp, for: indexPath as IndexPath) as? VerifyEmailOtpTableViewCell
        cell?.backgroundColor = UIColor.clear
        cell?.delegate = self
        cell?.configCell(email: self.viewModel.authenRequest.email)
        return cell ?? VerifyEmailOtpTableViewCell()
    }
}

extension EnterCodeViewController: VerifyEmailOtpTableViewCellDelegate {
    func didRequestOtp(_ cell: VerifyEmailOtpTableViewCell) {
        self.hud.textLabel.text = "Sending"
        self.hud.show(in: self.view)
        self.viewModel.requestOtpWithEmail()
    }

    func didConfirm(_ cell: VerifyEmailOtpTableViewCell, pin: String) {
        self.hud.textLabel.text = "Verifying"
        self.hud.show(in: self.view)
        self.viewModel.authenRequest.otp = pin
        self.viewModel.verifyOtpWithEmail()
    }
}
