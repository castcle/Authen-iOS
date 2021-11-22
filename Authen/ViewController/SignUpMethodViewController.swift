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
//  SignUpMethodViewController.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 28/7/2564 BE.
//

import UIKit
import Core
import Component
import PanModal
import ActiveLabel
import Defaults

public class SignUpMethodViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var twitterLabel: UILabel!
    @IBOutlet var appleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var agreementLabel: ActiveLabel!
    @IBOutlet var loginLabel: ActiveLabel!
    @IBOutlet var otherLabel: ActiveLabel!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var twitterView: UIView!
    @IBOutlet var appleView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var twitterImage: UIImageView!
    @IBOutlet var appleImage: UIImageView!
    @IBOutlet var emailImage: UIImageView!
    
    var maxHeight = (UIScreen.main.bounds.height - 480)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.backgroundView.backgroundColor = UIColor.Asset.darkGray
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .h3)
        self.titleLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.twitterLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.twitterLabel.textColor = UIColor.Asset.white
        self.appleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.appleLabel.textColor = UIColor.Asset.white
        self.emailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.emailLabel.textColor = UIColor.Asset.white
        self.twitterView.custom(color: UIColor.Asset.twitter, cornerRadius: 10)
        self.appleView.custom(color: UIColor.Asset.apple, cornerRadius: 10)
        self.emailView.custom(color: UIColor.Asset.black, cornerRadius: 10)
        
        self.twitterImage.image = UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.appleImage.image = UIImage.init(icon: .castcle(.apple), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.emailImage.image = UIImage.init(icon: .castcle(.email), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = Localization.AuthenMethod.title.text
        self.subTitleLabel.text = Localization.AuthenMethod.subtitle.text
        self.agreementLabel.text = "\(Localization.AuthenMethod.subtitleUserAgreement.text) \(Localization.AuthenMethod.subtitleAnd.text) \(Localization.AuthenMethod.subtitlePrivacyPolicy.text)"
        self.agreementLabel.customize { label in
            label.font = UIFont.asset(.light, fontSize: .overline)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.white
            
            let agreementType = ActiveType.custom(pattern: Localization.AuthenMethod.subtitleUserAgreement.text)
            let policyType = ActiveType.custom(pattern: Localization.AuthenMethod.subtitlePrivacyPolicy.text)
            
            label.enabledTypes = [agreementType, policyType]
            label.customColor[agreementType] = UIColor.Asset.lightBlue
            label.customSelectedColor[agreementType] = UIColor.Asset.gray
            label.customColor[policyType] = UIColor.Asset.lightBlue
            label.customSelectedColor[policyType] = UIColor.Asset.gray
            
            label.handleCustomTap(for: agreementType) { element in
                self.openWebView(urlString: Environment.userAgreement)
            }
            
            label.handleCustomTap(for: policyType) { element in
                self.openWebView(urlString: Environment.privacyPolicy)
            }
        }
        self.loginLabel.text = "\(Localization.AuthenMethod.alreadyAccount.text) \(Localization.AuthenMethod.login.text)"
        self.loginLabel.customize { label in
            label.font = UIFont.asset(.light, fontSize: .body)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.white
            
            let logType = ActiveType.custom(pattern: Localization.AuthenMethod.login.text)
            
            label.enabledTypes = [logType]
            label.customColor[logType] = UIColor.Asset.lightBlue
            label.customSelectedColor[logType] = UIColor.Asset.gray
            
            label.handleCustomTap(for: logType) { element in
                self.dismiss(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
                    Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.signIn(showSignUp: true)), animated: true)
                }
            }
        }
        self.otherLabel.customize { label in
            label.font = UIFont.asset(.light, fontSize: .small)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.white
            
            let joinUsType = ActiveType.custom(pattern: Localization.AuthenMethod.joinUs.text)
            let docsType = ActiveType.custom(pattern: Localization.AuthenMethod.docs.text)
            let whitepaperType = ActiveType.custom(pattern: Localization.AuthenMethod.whitepaper.text)
            let versionType = ActiveType.custom(pattern: "\(Localization.AuthenMethod.version.text) \(Defaults[.appVersion]) - \(Defaults[.appBuild])")
            
            label.enabledTypes = [joinUsType, docsType, whitepaperType, versionType]
            
            label.customColor[joinUsType] = UIColor.Asset.white
            label.customSelectedColor[joinUsType] = UIColor.Asset.gray
            label.customColor[docsType] = UIColor.Asset.white
            label.customSelectedColor[docsType] = UIColor.Asset.gray
            label.customColor[whitepaperType] = UIColor.Asset.white
            label.customSelectedColor[whitepaperType] = UIColor.Asset.gray
            label.customColor[versionType] = UIColor.Asset.gray
            label.customSelectedColor[versionType] = UIColor.Asset.gray
            
            label.handleCustomTap(for: joinUsType) { element in
                self.openWebView(urlString: Environment.joinUs)
            }
            
            label.handleCustomTap(for: docsType) { element in
                self.openWebView(urlString: Environment.docs)
            }
            
            label.handleCustomTap(for: whitepaperType) { element in
                self.openWebView(urlString: Environment.whitepaper)
            }
        }
        self.otherLabel.text = "\(Localization.AuthenMethod.joinUs.text) | \(Localization.AuthenMethod.docs.text) | \(Localization.AuthenMethod.whitepaper.text) | \(Localization.AuthenMethod.version.text) \(Defaults[.appVersion]) (\(Defaults[.appBuild]))"
        self.twitterLabel.text = Localization.AuthenMethod.twitter.text
        self.appleLabel.text = Localization.AuthenMethod.apple.text
        self.emailLabel.text = Localization.AuthenMethod.email.text
    }
    
    private func openWebView(urlString: String) {
        self.dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: urlString)!)), animated: true)
        }
    }
    
    @IBAction func twitterAction(_ sender: Any) {
        self.dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.mergeAccount(MergeAccountViewModel(socialType: .twitter))), animated: true)
        }
    }
    
    @IBAction func appleAction(_ sender: Any) {
        self.dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.mergeAccount(MergeAccountViewModel(socialType: .apple))), animated: true)
        }
    }
    
    @IBAction func emailAction(_ sender: Any) {
        self.dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.email(fromSignIn: false)), animated: true)
        }
    }
}

extension SignUpMethodViewController: PanModalPresentable {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var panScrollable: UIScrollView? {
        return nil
    }

    public var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(self.maxHeight)
    }

    public var anchorModalToLongForm: Bool {
        return false
    }
}
