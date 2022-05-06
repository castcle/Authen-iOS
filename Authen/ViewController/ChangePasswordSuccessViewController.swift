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
//  ChangePasswordSuccessViewController.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 30/8/2564 BE.
//

import UIKit
import Core
import Defaults
import SwiftColor

class ChangePasswordSuccessViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    
    var viewModel = ChangePasswordViewModel(.changePassword)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.titleLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.confirmButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.confirmButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.confirmButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.confirmButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        
        if self.viewModel.changePasswordType == .changePassword {
            self.confirmButton.setTitle("Back", for: .normal)
        } else if self.viewModel.changePasswordType == .forgotPassword {
            self.confirmButton.setTitle("Log in with Castcle", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        Defaults[.screenId] = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        if self.viewModel.changePasswordType == .changePassword {
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
        } else if self.viewModel.changePasswordType == .forgotPassword {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
}
