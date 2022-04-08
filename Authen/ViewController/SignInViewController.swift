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
//  SignInViewController.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 30/7/2564 BE.
//

import UIKit
import Core
//import IGListKit
import Defaults

class SignInViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.setupNavBar()
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.primary, title: "")
        var rightButton: [UIBarButtonItem] = []
        let rightIcon = NavBarButtonType.close.barButton
        rightIcon.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)
        rightButton.append(UIBarButtonItem(customView: rightIcon))
        self.navigationItem.rightBarButtonItems = rightButton
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: AuthenNibVars.TableViewCell.signIn, bundle: ConfigBundle.authen), forCellReuseIdentifier: AuthenNibVars.TableViewCell.signIn)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    @objc private func closeAction() {
        self.dismiss(animated: true)
    }
}

extension SignInViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AuthenNibVars.TableViewCell.signIn, for: indexPath as IndexPath) as? SignInTableViewCell
        cell?.backgroundColor = UIColor.clear
        cell?.delegate = self
        return cell ?? SignInTableViewCell()
    }
}

extension SignInViewController: SignInTableViewCellDelegate {
    func didLoginWithFacebook(_ signInTableViewCell: SignInTableViewCell) {
        //
    }
    
    func didLoginWithTwitter(_ signInTableViewCell: SignInTableViewCell) {
        //
    }
    
    func didLoginWithGoogle(_ signInTableViewCell: SignInTableViewCell) {
        //
    }
    
    func didLoginWithApple(_ signInTableViewCell: SignInTableViewCell) {
        //
    }
}
