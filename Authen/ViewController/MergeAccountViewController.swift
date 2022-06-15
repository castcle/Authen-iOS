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
//  MergeAccountViewController.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 17/9/2564 BE.
//

import UIKit
import Core
import Networking
import Defaults
import Kingfisher
import JGProgressHUD

class MergeAccountViewController: UIViewController {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var socialAvatarImage: UIImageView!
    @IBOutlet var castcleAvatarImage: UIImageView!
    @IBOutlet var socialNameLabel: UILabel!
    @IBOutlet var socialIdLabel: UILabel!
    @IBOutlet var castcleNameLabel: UILabel!
    @IBOutlet var castcleIdLabel: UILabel!
    @IBOutlet var sicialIconView: UIView!
    @IBOutlet var socialIcon: UIImageView!
    @IBOutlet var castcleIconView: UIView!
    @IBOutlet var castcleIcon: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var nextIcon: UIImageView!
    @IBOutlet var mergeButton: UIButton!

    var viewModel = MergeAccountViewModel(userInfo: UserInfo(), authenRequest: AuthenRequest())
    let hud = JGProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.detailLabel.textColor = UIColor.Asset.white
        self.socialNameLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.socialNameLabel.textColor = UIColor.Asset.white
        self.socialIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.socialIdLabel.textColor = UIColor.Asset.lightGray
        self.castcleNameLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.castcleNameLabel.textColor = UIColor.Asset.white
        self.castcleIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.castcleIdLabel.textColor = UIColor.Asset.lightGray
        self.socialAvatarImage.circle(color: UIColor.Asset.white)
        self.socialAvatarImage.image = UIImage.Asset.userPlaceholder
        self.castcleAvatarImage.circle(color: UIColor.Asset.white)
        self.castcleAvatarImage.image = UIImage.Asset.userPlaceholder
        self.sicialIconView.capsule(color: self.viewModel.color, borderWidth: 2, borderColor: UIColor.Asset.black)
        self.castcleIconView.capsule(color: UIColor.Asset.black, borderWidth: 2, borderColor: UIColor.Asset.black)
        self.socialIcon.image = self.viewModel.icon
        self.castcleIcon.image = UIImage.init(icon: .castcle(.logo), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.nextIcon.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        let castcleAvatarUrl = URL(string: self.viewModel.userInfo.images.avatar.thumbnail)
        self.castcleAvatarImage.kf.setImage(with: castcleAvatarUrl, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.castcleNameLabel.text = self.viewModel.userInfo.displayName
        self.castcleIdLabel.text = "@\(self.viewModel.userInfo.castcleId)"
        let socialAvatarUrl = URL(string: self.viewModel.authenRequest.avatar)
        self.socialAvatarImage.kf.setImage(with: socialAvatarUrl, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.socialNameLabel.text = self.viewModel.authenRequest.displayName
        self.socialIdLabel.text = ""
        self.mergeButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        self.mergeButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.mergeButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
        self.hud.textLabel.text = "Sending"
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "", textColor: UIColor.Asset.lightBlue)
    }

    @IBAction func mergeAction(_ sender: Any) {
        self.hud.show(in: self.view)
        self.viewModel.authenRequest.objective = .mergeAccount
        self.viewModel.authenRequest.email = self.viewModel.userInfo.email
        self.viewModel.requestOtpWithEmail()
    }
}

extension MergeAccountViewController: MergeAccountViewModelDelegate {
    func didRequestOtpFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.enterCode(EnterCodeViewModel(verifyCodeType: .mergeAccount, authenRequest: self.viewModel.authenRequest))), animated: true)
        }
    }
}
