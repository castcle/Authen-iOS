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
//  ForgotPasswordViewController.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 31/8/2564 BE.
//

import UIKit
import Core
import Defaults

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var sentLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var frameView: UIView!
    @IBOutlet var dotView: UIView!
    @IBOutlet var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.setupNavBar()
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .h2)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.detailLabel.textColor = UIColor.Asset.white
        
        self.nameLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.nameLabel.textColor = UIColor.Asset.white
        self.typeLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.typeLabel.textColor = UIColor.Asset.gray
        self.sentLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.sentLabel.textColor = UIColor.Asset.white
        self.emailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.emailLabel.textColor = UIColor.Asset.gray
        
        self.continueButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.continueButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.continueButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.continueButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        
        self.avatarImage.circle(color: UIColor.Asset.white)
        
        let url = URL(string: UserState.shared.avatar)
        self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.5))])
        self.nameLabel.text = UserState.shared.name
        self.emailLabel.text = UserState.shared.email
        
        self.frameView.capsule(color: UIColor.Asset.darkGraphiteBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.dotView.capsule(color: UIColor.Asset.lightBlue)
        self.avatarImage.circle(color: UIColor.Asset.white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Forget Password")
    }

    @IBAction func continueAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.enterCode), animated: true)
    }
}