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
//  VerifyEmailViewController.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 2/8/2564 BE.
//

import UIKit
import Core

class VerifyEmailViewController: UIViewController {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var getNewEmailLabel: UILabel!
    @IBOutlet var resendButton: UIButton!
    @IBOutlet var feedButton: UIButton!
    @IBOutlet var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.getNewEmailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.getNewEmailLabel.textColor = UIColor.Asset.white
        self.resendButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .body)
        self.resendButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.feedButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.feedButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.feedButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
        self.feedButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.profileButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.profileButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.profileButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.profileButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func resendAction(_ sender: Any) {
    }
    
    @IBAction func feedAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func profileAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.resendEmail), animated: true)
    }
}
