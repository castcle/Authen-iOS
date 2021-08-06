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
//  ResendEmailViewController.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 3/8/2564 BE.
//

import UIKit
import Core
import ActiveLabel

class ResendEmailViewController: UIViewController {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var firstLabel: ActiveLabel! {
        didSet {
            self.firstLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .body)
                label.numberOfLines = 0
                label.textColor = UIColor.Asset.white
                
                let emailType = ActiveType.custom(pattern: "Castcle@gmail.com")
                label.enabledTypes = [emailType]
                label.customColor[emailType] = UIColor.Asset.lightBlue
                label.customSelectedColor[emailType] = UIColor.Asset.lightBlue
            }
        }
    }
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    @IBOutlet var resendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.secondLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.secondLabel.textColor = UIColor.Asset.white
        self.thirdLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.thirdLabel.textColor = UIColor.Asset.white
        self.resendButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.resendButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.resendButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.resendButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "")
    }
    
    @IBAction func resendAction(_ sender: Any) {
    }
}
