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
//  SocialLoginViewModel.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 24/1/2565 BE.
//

import Core
import Networking
import SwiftyJSON
import Defaults
import RealmSwift

public protocol SocialLoginViewModelDelegate: AnyObject {
    func didSocialLoginFinish(success: Bool)
    func didMergeAccount(userInfo: UserInfo)
}

class SocialLoginViewModel {
    public var delegate: SocialLoginViewModelDelegate?
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    var notificationRepository: NotificationRepository = NotificationRepositoryImpl()
    var authenRequest: AuthenRequest = AuthenRequest()
    var notificationRequest: NotificationRequest = NotificationRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var state: State = .none

    // MARK: - Input
    public init() {
        self.tokenHelper.delegate = self
    }

    public func socialLogin() {
        self.state = .login
        self.authenticationRepository.loginWithSocial(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let realm = try Realm()
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let code = json[JsonKey.code.rawValue].stringValue
                    if code == "3021" {
                        let payload = JSON(json[JsonKey.payload.rawValue].dictionaryValue)
                        let profile = JSON(payload[JsonKey.profile.rawValue].dictionaryValue)
                        let userInfo = UserInfo(json: profile)
                        self.delegate?.didMergeAccount(userInfo: userInfo)
                    } else {
                        let registered: Bool = json[JsonKey.registered.rawValue].boolValue
                        let accessToken = json[JsonKey.accessToken.rawValue].stringValue
                        let refreshToken = json[JsonKey.refreshToken.rawValue].stringValue
                        let profile = JSON(json[JsonKey.profile.rawValue].dictionaryValue)
                        let pages = json[JsonKey.pages.rawValue].arrayValue

                        UserHelper.shared.updateLocalProfile(user: UserInfo(json: profile))
                        UserHelper.shared.clearSeenContent()
                        NotifyHelper.shared.getBadges()

                        if self.authenRequest.provider == .twitter && !registered {
                            Defaults[.syncTwitter] = false
                        } else {
                            Defaults[.syncTwitter] = true
                        }

                        let pageRealm = realm.objects(Page.self)
                        try realm.write {
                            realm.delete(pageRealm)
                        }
                        UserHelper.shared.updatePage(pages: pages)
                        UserManager.shared.setUserRole(userRole: .user)
                        UserManager.shared.setAccessToken(token: accessToken)
                        UserManager.shared.setRefreshToken(token: refreshToken)
                        if !registered {
                            self.sendAnalytics(eventType: .registration)
                        } else {
                            self.sendAnalytics(eventType: .login)
                        }
                        self.registerNotificationToken()
                        self.delegate?.didSocialLoginFinish(success: true)
                    }
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didSocialLoginFinish(success: false)
                }
            }
        }
    }

    private func sendAnalytics(eventType: TrackingEventType) {
        let item = Analytic()
        item.accountId = UserManager.shared.accountId
        item.userId = UserManager.shared.id
        item.channel = self.getTrackingChennel().rawValue
        TrackingAnalyticHelper.shared.sendTrackingAnalytic(eventType: eventType, item: item)
    }

    private func getTrackingChennel() -> TrackingChennel {
        if self.authenRequest.provider == .facebook {
            return .facebook
        } else if self.authenRequest.provider == .twitter {
            return .twitter
        } else if self.authenRequest.provider == .google {
            return .google
        } else if self.authenRequest.provider == .apple {
            return .apple
        } else {
            return .unkown
        }
    }

    private func registerNotificationToken() {
        self.state = .registerToken
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

extension SocialLoginViewModel: TokenHelperDelegate {
    func didRefreshTokenFinish() {
        if self.state == .login {
            self.socialLogin()
        } else if self.state == .registerToken {
            self.registerNotificationToken()
        }
    }
}
