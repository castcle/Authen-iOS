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
import Networking
import Component
import PanModal
import ActiveLabel
import Defaults
import AuthenticationServices
import Swifter
import SafariServices
import GoogleSignIn
import FBSDKLoginKit
import JGProgressHUD

public class SignUpMethodViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var facebookLabel: UILabel!
    @IBOutlet var twitterLabel: UILabel!
    @IBOutlet var googleLabel: UILabel!
    @IBOutlet var appleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var agreementLabel: ActiveLabel!
    @IBOutlet var loginLabel: ActiveLabel!
    @IBOutlet var otherLabel: ActiveLabel!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var facebookView: UIView!
    @IBOutlet var twitterView: UIView!
    @IBOutlet var googleView: UIView!
    @IBOutlet var appleView: UIView!
    @IBOutlet var emailView: UIView!
    
    @IBOutlet var facebookImage: UIImageView!
    @IBOutlet var twitterImage: UIImageView!
    @IBOutlet var googleImage: UIImageView!
    @IBOutlet var appleImage: UIImageView!
    @IBOutlet var emailImage: UIImageView!
    
    var viewModel = SocialLoginViewModel()
    var maxHeight = (UIScreen.main.bounds.height - 585)
    var swifter: Swifter!
    var accToken: Credential.OAuthAccessToken?
    let hud = JGProgressHUD()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.hud.textLabel.text = "Loading"
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.backgroundView.backgroundColor = UIColor.Asset.darkGray
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .h3)
        self.titleLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.subTitleLabel.textColor = UIColor.Asset.white
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
        self.facebookView.custom(color: UIColor.Asset.facebook, cornerRadius: 10)
        self.twitterView.custom(color: UIColor.Asset.twitter, cornerRadius: 10)
        self.googleView.custom(color: UIColor.Asset.white, cornerRadius: 10)
        self.appleView.custom(color: UIColor.Asset.apple, cornerRadius: 10)
        self.emailView.custom(color: UIColor.Asset.black, cornerRadius: 10)
        
        self.facebookImage.image = UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.twitterImage.image = UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.googleImage.image = UIImage.Asset.googleLogo
        self.appleImage.image = UIImage.init(icon: .castcle(.apple), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.emailImage.image = UIImage.init(icon: .castcle(.email), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = Localization.authenMethod.title.text
        self.subTitleLabel.text = Localization.authenMethod.subtitle.text
        self.agreementLabel.text = "\(Localization.authenMethod.subtitleUserAgreement.text) \(Localization.authenMethod.subtitleAnd.text) \(Localization.authenMethod.subtitlePrivacyPolicy.text)"
        self.agreementLabel.customize { label in
            label.font = UIFont.asset(.light, fontSize: .overline)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.white
            
            let agreementType = ActiveType.custom(pattern: Localization.authenMethod.subtitleUserAgreement.text)
            let policyType = ActiveType.custom(pattern: Localization.authenMethod.subtitlePrivacyPolicy.text)
            
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
        self.loginLabel.text = "\(Localization.authenMethod.alreadyAccount.text) \(Localization.authenMethod.login.text)"
        self.loginLabel.customize { label in
            label.font = UIFont.asset(.light, fontSize: .body)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.white
            
            let logType = ActiveType.custom(pattern: Localization.authenMethod.login.text)
            
            label.enabledTypes = [logType]
            label.customColor[logType] = UIColor.Asset.lightBlue
            label.customSelectedColor[logType] = UIColor.Asset.gray
            
            label.handleCustomTap(for: logType) { element in
                self.dismiss(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Utility.currentViewController().navigationController?.popToRootViewController(animated: false)
                    Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.signIn(showSignUp: true)), animated: true)
                }
            }
        }
        self.otherLabel.customize { label in
            label.font = UIFont.asset(.light, fontSize: .small)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.white
            
            let joinUsType = ActiveType.custom(pattern: Localization.authenMethod.joinUs.text)
            let docsType = ActiveType.custom(pattern: Localization.authenMethod.docs.text)
            let whitepaperType = ActiveType.custom(pattern: Localization.authenMethod.whitepaper.text)
            let versionType = ActiveType.custom(pattern: "\(Localization.authenMethod.version.text) \(Defaults[.appVersion]) (\(Defaults[.appBuild]))")
            
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
        self.otherLabel.text = "\(Localization.authenMethod.joinUs.text) | \(Localization.authenMethod.docs.text) | \(Localization.authenMethod.whitepaper.text) | \(Localization.authenMethod.version.text) \(Defaults[.appVersion]) (\(Defaults[.appBuild]))"
        self.twitterLabel.text = Localization.authenMethod.twitter.text
        self.googleLabel.text = Localization.authenMethod.google.text
        self.appleLabel.text = Localization.authenMethod.apple.text
        self.emailLabel.text = Localization.authenMethod.email.text
    }
    
    private func openWebView(urlString: String) {
        self.dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Utility.currentViewController().navigationController?.popToRootViewController(animated: false)
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: urlString)!)), animated: true)
        }
    }
    
    @IBAction func facebookAction(_ sender: Any) {
        let loginManager = LoginManager()
        if let _ = AccessToken.current {
            loginManager.logOut()
        } else {
            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    return
                }
                
                Profile.loadCurrentProfile { (profile, error) in
                    let userId: String = profile?.userID ?? ""
                    let email: String = profile?.email ?? ""
                    let fullName: String = profile?.name ?? ""
                    let profilePicUrl: String = "http://graph.facebook.com/\(AccessToken.current?.userID ?? "")/picture?type=large"
                    let accessToken: String = AccessToken.current?.tokenString ?? ""
                    
                    var authenRequest: AuthenRequest = AuthenRequest()
                    authenRequest.provider = .facebook
                    authenRequest.uid = userId
                    authenRequest.displayName = fullName
                    authenRequest.avatar = profilePicUrl
                    authenRequest.email = email
                    authenRequest.authToken = accessToken
                    
                    self.dismiss(animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        Utility.currentViewController().navigationController?.popToRootViewController(animated: false)
                        self.hud.show(in: Utility.currentViewController().view)
                        self.viewModel.authenRequest = authenRequest
                        self.viewModel.socialLogin()
                    }
                }
            }
        }
    }
    
    @IBAction func twitterAction(_ sender: Any) {
        self.swifter = Swifter(consumerKey: TwitterConstants.key, consumerSecret: TwitterConstants.secretKey)
        self.swifter.authorize(withProvider: self, callbackURL: URL(string: TwitterConstants.callbackUrl)!) { accessToken, response in
            self.accToken = accessToken
            self.getUserProfile()
        } failure: { error in
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    @IBAction func googleAction(_ sender: Any) {
        let signInConfig = GIDConfiguration.init(clientID: "399197784684-qu71doj4dn7ftksq09i7hvgeot4vbd4c.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            let userId: String = user.userID ?? ""
            let email: String = user.profile?.email ?? ""
            let fullName: String = user.profile?.name ?? ""
            let profilePicUrl: String = user.profile?.imageURL(withDimension: 320)?.absoluteString ?? ""
            let accessToken: String = user.authentication.accessToken
            
            var authenRequest: AuthenRequest = AuthenRequest()
            authenRequest.provider = .google
            authenRequest.uid = userId
            authenRequest.displayName = fullName
            authenRequest.avatar = profilePicUrl
            authenRequest.email = email
            authenRequest.authToken = accessToken
            
            self.dismiss(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Utility.currentViewController().navigationController?.popToRootViewController(animated: false)
                self.hud.show(in: Utility.currentViewController().view)
                self.viewModel.authenRequest = authenRequest
                self.viewModel.socialLogin()
            }
          }
    }
    
    @IBAction func appleAction(_ sender: Any) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction func emailAction(_ sender: Any) {
        self.dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Utility.currentViewController().navigationController?.popToRootViewController(animated: false)
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.email(fromSignIn: false)), animated: true)
        }
    }
}

extension SignUpMethodViewController: SocialLoginViewModelDelegate {
    public func didSocialLoginFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            Defaults[.startLoadFeed] = true
            NotificationCenter.default.post(name: .resetFeedContent, object: nil)
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

extension SignUpMethodViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let email: String = appleIdCredential.email ?? ""
            let givenName: String = appleIdCredential.fullName?.givenName ?? ""
            let familyName: String = appleIdCredential.fullName?.familyName ?? ""
            var fullName: String {
                if !givenName.isEmpty && !familyName.isEmpty {
                    return "\(givenName) \(familyName)"
                } else if !givenName.isEmpty && familyName.isEmpty {
                    return givenName
                } else if givenName.isEmpty && !familyName.isEmpty {
                    return familyName
                } else {
                    return ""
                }
            }
            
            if KeychainHelper.shared.getKeychainWith(with: .appleUserId) != appleIdCredential.user {
                KeychainHelper.shared.setKeychainWith(with: .appleUserId, value: appleIdCredential.user)
                KeychainHelper.shared.setKeychainWith(with: .appleEmail, value: email)
                KeychainHelper.shared.setKeychainWith(with: .appleFullName, value: fullName)
            }
            
            var authenRequest: AuthenRequest = AuthenRequest()
            authenRequest.provider = .apple
            authenRequest.uid = KeychainHelper.shared.getKeychainWith(with: .appleUserId)
            authenRequest.displayName = KeychainHelper.shared.getKeychainWith(with: .appleFullName)
            authenRequest.email = KeychainHelper.shared.getKeychainWith(with: .appleEmail)
            
            self.dismiss(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Utility.currentViewController().navigationController?.popToRootViewController(animated: false)
                self.hud.show(in: Utility.currentViewController().view)
                self.viewModel.authenRequest = authenRequest
                self.viewModel.socialLogin()
            }
        }
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func alertText(string: String) {
        let alert = UIAlertController(title: "Info", message: string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        Utility.currentViewController().present(alert, animated: true, completion: nil)
    }
}

extension SignUpMethodViewController: SFSafariViewControllerDelegate, ASWebAuthenticationPresentationContextProviding {
    func getUserProfile() {
        self.swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { json in
            let twitterId: String = json["id_str"].string ?? ""
            let twitterName: String = json["name"].string ?? ""
            let twitterEmail: String = json["email"].string ?? ""
            let twitterProfilePic: String = json["profile_image_url_https"].string?.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil) ?? ""
            
            var authenRequest: AuthenRequest = AuthenRequest()
            authenRequest.provider = .twitter
            authenRequest.uid = twitterId
            authenRequest.displayName = twitterName
            authenRequest.avatar = twitterProfilePic
            authenRequest.email = twitterEmail
            authenRequest.authToken = self.accToken?.key ?? ""
            
            self.dismiss(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Utility.currentViewController().navigationController?.popToRootViewController(animated: false)
                self.hud.show(in: Utility.currentViewController().view)
                self.viewModel.authenRequest = authenRequest
                self.viewModel.socialLogin()
            }
        }) { error in
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window!
    }
}
