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
//  Created by Tanakorn Phoochaliaw on 28/7/2564 BE.
//

import UIKit
import Core
import Component
import PanModal
import ActiveLabel

public class SignUpMethodViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var telegramLabel: UILabel!
    @IBOutlet var facebookLabel: UILabel!
    @IBOutlet var twitterLabel: UILabel!
    @IBOutlet var googleLabel: UILabel!
    @IBOutlet var appleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    @IBOutlet var agreementLabel: ActiveLabel! {
        didSet {
            self.agreementLabel.customize { label in
                label.font = UIFont.asset(.light, fontSize: .overline)
                label.numberOfLines = 1
                label.textColor = UIColor.Asset.white
                
                let agreementType = ActiveType.custom(pattern: "User Agreement")
                let policyType = ActiveType.custom(pattern: "Privacy Policy")
                
                label.enabledTypes = [agreementType, policyType]
                label.customColor[agreementType] = UIColor.Asset.lightBlue
                label.customSelectedColor[agreementType] = UIColor.Asset.lightBlue
                label.customColor[policyType] = UIColor.Asset.lightBlue
                label.customSelectedColor[policyType] = UIColor.Asset.lightBlue
                
                label.handleCustomTap(for: agreementType) { element in
                    self.openWebView(urlString: "https://ethereum.org/en/terms-of-use/")
                }
                
                label.handleCustomTap(for: policyType) { element in
                    self.openWebView(urlString: "https://ethereum.org/en/privacy-policy/")
                }
            }
        }
    }
    @IBOutlet var loginLabel: ActiveLabel! {
        didSet {
            self.loginLabel.customize { label in
                label.font = UIFont.asset(.light, fontSize: .body)
                label.numberOfLines = 1
                label.textColor = UIColor.Asset.white
                
                let logType = ActiveType.custom(pattern: "Login")
                
                label.enabledTypes = [logType]
                label.customColor[logType] = UIColor.Asset.lightBlue
                label.customSelectedColor[logType] = UIColor.Asset.lightBlue
                
                label.handleCustomTap(for: logType) { element in
                    self.dismiss(animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                        Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.signIn), animated: true)
                    }
                }
            }
        }
    }
    @IBOutlet var otherLabel: ActiveLabel! {
        didSet {
            self.otherLabel.customize { label in
                label.font = UIFont.asset(.light, fontSize: .overline)
                label.numberOfLines = 1
                label.textColor = UIColor.Asset.white
                
                let joinUsType = ActiveType.custom(pattern: "Join us")
                let manifestoType = ActiveType.custom(pattern: "Manifesto")
                let whitepaperType = ActiveType.custom(pattern: "Whitepaper")
                let versionType = ActiveType.custom(pattern: "V.1")
                
                label.enabledTypes = [joinUsType, manifestoType, whitepaperType, versionType]
                
                label.customColor[joinUsType] = UIColor.Asset.white
                label.customSelectedColor[joinUsType] = UIColor.Asset.white
                label.customColor[manifestoType] = UIColor.Asset.white
                label.customSelectedColor[manifestoType] = UIColor.Asset.white
                label.customColor[whitepaperType] = UIColor.Asset.white
                label.customSelectedColor[whitepaperType] = UIColor.Asset.white
                label.customColor[versionType] = UIColor.Asset.gray
                label.customSelectedColor[versionType] = UIColor.Asset.gray
                
                label.handleCustomTap(for: joinUsType) { element in
                    self.openWebView(urlString: "https://ethereum.org/en/terms-of-use/")
                }
                
                label.handleCustomTap(for: manifestoType) { element in
                    self.openWebView(urlString: "https://ethereum.org/en/privacy-policy/")
                }
                
                label.handleCustomTap(for: whitepaperType) { element in
                    self.openWebView(urlString: "https://ethereum.org/en/privacy-policy/")
                }
            }
        }
    }
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var telegramView: UIView!
    @IBOutlet var facebookView: UIView!
    @IBOutlet var twitterView: UIView!
    @IBOutlet var googleView: UIView!
    @IBOutlet var appleView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var telegramImage: UIImageView!
    @IBOutlet var facebookImage: UIImageView!
    @IBOutlet var twitterImage: UIImageView!
    @IBOutlet var googleImage: UIImageView!
    @IBOutlet var appleImage: UIImageView!
    @IBOutlet var emailImage: UIImageView!
    
    var maxHeight = (UIScreen.main.bounds.height - 650)
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.backgroundView.backgroundColor = UIColor.Asset.darkGray
        self.titleLabel.font = UIFont.asset(.medium, fontSize: .h3)
        self.titleLabel.textColor = UIColor.Asset.white
        
        self.subTitleLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.subTitleLabel.textColor = UIColor.Asset.white
        
        self.telegramLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.telegramLabel.textColor = UIColor.Asset.white
        self.facebookLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.facebookLabel.textColor = UIColor.Asset.white
        self.twitterLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.twitterLabel.textColor = UIColor.Asset.white
        self.googleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.googleLabel.textColor = UIColor.Asset.black
        self.appleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.appleLabel.textColor = UIColor.Asset.white
        self.emailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.emailLabel.textColor = UIColor.Asset.white
        
        self.telegramView.custom(color: UIColor.Asset.telegram, cornerRadius: 10)
        self.facebookView.custom(color: UIColor.Asset.facebook, cornerRadius: 10)
        self.twitterView.custom(color: UIColor.Asset.twitter, cornerRadius: 10)
        self.googleView.custom(color: UIColor.Asset.white, cornerRadius: 10)
        self.appleView.custom(color: UIColor.Asset.apple, cornerRadius: 10)
        self.emailView.custom(color: UIColor.Asset.black, cornerRadius: 10)
        
        self.googleImage.image = UIImage.Asset.googleLogo
    }
    
    private func openWebView(urlString: String) {
        self.dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: urlString)!)), animated: true)
        }
    }
    
    @IBAction func telegramAction(_ sender: Any) {
    }
    
    @IBAction func facebookAction(_ sender: Any) {
    }
    
    @IBAction func twitterAction(_ sender: Any) {
    }
    
    @IBAction func googleAction(_ sender: Any) {
    }
    
    @IBAction func appleAction(_ sender: Any) {
    }
    
    @IBAction func emailAction(_ sender: Any) {
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
