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
//  Created by Tanakorn Phoochaliaw on 30/8/2564 BE.
//

import UIKit

class ChangePasswordSuccessViewController: UIViewController {

    @IBOutlet var frameImage: UIImageView!
    @IBOutlet var successImage: UIImageView!
    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .h3)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.homeButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.homeButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.homeButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.homeButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        
        self.frameImage.capsule(color: UIColor.clear, borderWidth: 6.0, borderColor: UIColor.Asset.lightBlue)
        self.successImage.image = UIImage.init(icon: .castcle(.checkmark), size: CGSize(width: 80, height: 80), textColor: UIColor.Asset.lightBlue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func homeAction(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
}
