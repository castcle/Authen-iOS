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
//  SignInViewController.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 30/7/2564 BE.
//

import UIKit
import Core
import Component
import Networking
import Defaults
import JGProgressHUD
import FBSDKLoginKit
import AuthenticationServices
import Swifter
import SafariServices
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    let hud = JGProgressHUD()
    var viewModel = SocialLoginViewModel()
    var swifter: Swifter!
    var accToken: Credential.OAuthAccessToken?

    enum SignInViewControllerSection: Int, CaseIterable {
        case signIn = 0
        case castcleAbout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.hideKeyboardWhenTapped()
        self.setupNavBar()
        self.configureTableView()
        self.viewModel.delegate = self
        self.hud.textLabel.text = "Logging in"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }

    func setupNavBar() {
        self.customNavigationBar(.primary, title: "")
        var rightButton: [UIBarButtonItem] = []
        let rightIcon = NavBarButtonType.close.barButton
        rightIcon.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)
        rightButton.append(UIBarButtonItem(customView: rightIcon))
        self.navigationItem.rightBarButtonItems = rightButton
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: AuthenNibVars.TableViewCell.signIn, bundle: ConfigBundle.authen), forCellReuseIdentifier: AuthenNibVars.TableViewCell.signIn)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.about, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.about)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    @objc private func closeAction() {
        self.dismiss(animated: true)
    }
}

extension SignInViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SignInViewControllerSection.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case SignInViewControllerSection.signIn.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: AuthenNibVars.TableViewCell.signIn, for: indexPath as IndexPath) as? SignInTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.delegate = self
            return cell ?? SignInTableViewCell()
        case SignInViewControllerSection.castcleAbout.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.about, for: indexPath as IndexPath) as? AboutTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell()
            return cell ?? AboutTableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

extension SignInViewController: SignInTableViewCellDelegate {
    func didLoginWithFacebook(_ signInTableViewCell: SignInTableViewCell) {
        let loginManager = LoginManager()
        if AccessToken.current != nil {
            loginManager.logOut()
        }
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
            Profile.loadCurrentProfile { (profile, _) in
                let userId: String = profile?.userID ?? ""
                let email: String = profile?.email ?? ""
                let fullName: String = profile?.name ?? ""
                let accessToken: String = AccessToken.current?.tokenString ?? ""
                let profilePicUrl: String = ConstantUrl.facebookAvatar(userId, accessToken).path
                var authenRequest: AuthenRequest = AuthenRequest()
                authenRequest.provider = .facebook
                authenRequest.socialId = userId
                authenRequest.displayName = fullName
                authenRequest.avatar = profilePicUrl
                authenRequest.email = email
                authenRequest.authToken = accessToken
                self.hud.show(in: self.view)
                self.viewModel.authenRequest = authenRequest
                self.viewModel.socialLogin()
            }
        }
    }

    func didLoginWithTwitter(_ signInTableViewCell: SignInTableViewCell) {
        self.swifter = Swifter(consumerKey: TwitterConstants.key, consumerSecret: TwitterConstants.secretKey)
        self.swifter.authorize(withProvider: self, callbackURL: URL(string: TwitterConstants.callbackUrl)!) { accessToken, _ in
            self.accToken = accessToken
            self.getUserProfile()
        } failure: { error in
            print("ERROR: \(error.localizedDescription)")
        }
    }

    func didLoginWithGoogle(_ signInTableViewCell: SignInTableViewCell) {
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
            authenRequest.socialId = userId
            authenRequest.displayName = fullName
            authenRequest.avatar = profilePicUrl
            authenRequest.email = email
            authenRequest.authToken = accessToken
            self.hud.show(in: self.view)
            self.viewModel.authenRequest = authenRequest
            self.viewModel.socialLogin()
        }
    }

    func didLoginWithApple(_ signInTableViewCell: SignInTableViewCell) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
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
            authenRequest.socialId = KeychainHelper.shared.getKeychainWith(with: .appleUserId)
            authenRequest.displayName = KeychainHelper.shared.getKeychainWith(with: .appleFullName)
            authenRequest.email = KeychainHelper.shared.getKeychainWith(with: .appleEmail)
            authenRequest.authToken = String(data: appleIdCredential.identityToken ?? Data(), encoding: .utf8) ?? ""

            self.hud.show(in: self.view)
            self.viewModel.authenRequest = authenRequest
            self.viewModel.socialLogin()
        }
    }

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension SignInViewController: SFSafariViewControllerDelegate, ASWebAuthenticationPresentationContextProviding {
    func getUserProfile() {
        self.swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: { json in
            let twitterId: String = json["id_str"].string ?? ""
            let twitterName: String = json["name"].string ?? ""
            let twitterEmail: String = json["email"].string ?? ""
            let twitterProfilePic: String = json["profile_image_url_https"].string?.replacingOccurrences(of: "_normal", with: "", options: .literal, range: nil) ?? ""
            let twitterDescription: String = json["description"].string ?? ""
            let twitterCover: String = json["profile_banner_url"].string ?? ""
            let twitterScreenName: String = json["screen_name"].string ?? ""
            var authenRequest: AuthenRequest = AuthenRequest()
            authenRequest.provider = .twitter
            authenRequest.socialId = twitterId
            authenRequest.displayName = twitterName
            authenRequest.avatar = twitterProfilePic
            authenRequest.email = twitterEmail
            authenRequest.overview = twitterDescription
            authenRequest.cover = twitterCover
            authenRequest.userName = twitterScreenName
            authenRequest.authToken = "\(self.accToken?.key ?? "")|\(self.accToken?.secret ?? "")"
            self.hud.show(in: self.view)
            self.viewModel.authenRequest = authenRequest
            self.viewModel.socialLogin()
        })
    }

    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension SignInViewController: SocialLoginViewModelDelegate {
    public func didSocialLoginFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            self.dismiss(animated: true)
            Defaults[.startLoadFeed] = true
            NotificationCenter.default.post(name: .resetFeedContent, object: nil)
            if !Defaults[.syncTwitter] {
                var pageSocial: PageSocial = PageSocial()
                pageSocial.provider = SocialType(rawValue: self.viewModel.authenRequest.provider.rawValue) ?? .unknow
                pageSocial.socialId = self.viewModel.authenRequest.socialId
                pageSocial.userName = self.viewModel.authenRequest.userName
                pageSocial.displayName = self.viewModel.authenRequest.displayName
                pageSocial.overview = self.viewModel.authenRequest.overview
                pageSocial.avatar = self.viewModel.authenRequest.avatar
                pageSocial.cover = self.viewModel.authenRequest.cover
                pageSocial.authToken = self.viewModel.authenRequest.authToken
                NotificationCenter.default.post(name: .syncTwittwerAutoPost, object: nil, userInfo: pageSocial.paramPageSocial)
            }
        }
    }

    public func didMergeAccount(userInfo: UserInfo) {
        self.hud.dismiss()
        self.dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.mergeAccount(MergeAccountViewModel(userInfo: userInfo, authenRequest: self.viewModel.authenRequest))), animated: true)
        }
    }
}
