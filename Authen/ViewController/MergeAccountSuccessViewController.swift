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
//  MergeAccountSuccessViewController.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 7/3/2565 BE.
//

import UIKit
import Core
import Defaults

class MergeAccountSuccessViewController: UIViewController {

    @IBOutlet var successImage: UIImageView!
    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.detailLabel.textColor = UIColor.Asset.white
        self.homeButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.homeButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.homeButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.homeButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Merge email")
    }
    
    @IBAction func homeAction(_ sender: Any) {
        Defaults[.startLoadFeed] = true
        self.navigationController!.popToRootViewController(animated: true)
    }
}
