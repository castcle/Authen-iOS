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
//  CreateDisplayNameCell.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 2/8/2564 BE.
//

import UIKit
import Core

class CreateDisplayNameCell: UICollectionViewCell {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var castcleIdLabel: UILabel!
    @IBOutlet var displayNameView: UIView!
    @IBOutlet var castcleIdPasswordView: UIView!
    @IBOutlet var nextButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.displayNameView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.castcleIdPasswordView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.castcleIdLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.castcleIdLabel.textColor = UIColor.Asset.white
        self.setupNextButton(isActive: false)
    }
    
    private func setupNextButton(isActive: Bool) {
        self.nextButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        
        if isActive {
            self.nextButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.nextButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }
    
    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 650)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let vc = AuthenOpener.open(.verifyEmail)
        Utility.currentViewController().navigationController?.pushViewController(vc, animated: true)
    }

}
