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
//  LoginViewModel.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 10/9/2564 BE.
//

import Core
import Networking
import SwiftyJSON
import Defaults
import RealmSwift

public protocol LoginViewModelDelegate: AnyObject {
    func didLoginFinish(success: Bool)
}

class LoginViewModel {

    public var delegate: LoginViewModelDelegate?
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    var notificationRepository: NotificationRepository = NotificationRepositoryImpl()
    var loginRequest: LoginRequest = LoginRequest()
    var notificationRequest: NotificationRequest = NotificationRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var viewState: ViewState = .none
    var showSignUp: Bool = true

    enum ViewState {
        case login
        case registerToken
        case none
    }

    // MARK: - Input
    public init(loginRequest: LoginRequest = LoginRequest()) {
        self.loginRequest = loginRequest
        self.tokenHelper.delegate = self
    }

    public func login() {
        self.viewState = .login
        self.authenticationRepository.login(loginRequest: self.loginRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let realm = try Realm()
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let accessToken = json[JsonKey.accessToken.rawValue].stringValue
                    let refreshToken = json[JsonKey.refreshToken.rawValue].stringValue
                    let profile = JSON(json[JsonKey.profile.rawValue].dictionaryValue)
                    let pages = json[JsonKey.pages.rawValue].arrayValue

                    UserHelper.shared.updateLocalProfile(user: UserInfo(json: profile))
                    UserHelper.shared.clearSeenContent()
                    NotifyHelper.shared.getBadges()

                    let pageRealm = realm.objects(Page.self)
                    try realm.write {
                        realm.delete(pageRealm)
                    }
                    try realm.write {
                        pages.forEach { page in
                            let pageInfo = UserInfo(json: page)
                            let pageTemp = Page()
                            pageTemp.id = pageInfo.id
                            pageTemp.castcleId = pageInfo.castcleId
                            pageTemp.displayName = pageInfo.displayName
                            pageTemp.avatar = pageInfo.images.avatar.thumbnail
                            pageTemp.cover = pageInfo.images.cover.fullHd
                            pageTemp.overview = pageInfo.overview
                            pageTemp.official = pageInfo.verified.official
                            pageTemp.isSyncTwitter = !pageInfo.syncSocial.twitter.socialId.isEmpty
                            pageTemp.isSyncFacebook = !pageInfo.syncSocial.facebook.socialId.isEmpty
                            realm.add(pageTemp, update: .modified)
                        }
                    }
                    UserManager.shared.setUserRole(userRole: .user)
                    UserManager.shared.setAccessToken(token: accessToken)
                    UserManager.shared.setRefreshToken(token: refreshToken)
                    self.registerNotificationToken()
                    self.delegate?.didLoginFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didLoginFinish(success: false)
                }
            }
        }
    }

    private func registerNotificationToken() {
        self.viewState = .registerToken
        self.notificationRequest.uuid = Defaults[.deviceUuid]
        self.notificationRequest.firebaseToken = Defaults[.firebaseToken]
        self.notificationRepository.registerToken(notificationRequest: self.notificationRequest) { (success, _, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
}

extension LoginViewModel: TokenHelperDelegate {
    func didRefreshTokenFinish() {
        if self.viewState == .login {
            self.login()
        } else if self.viewState == .registerToken {
            self.registerNotificationToken()
        }
    }
}
