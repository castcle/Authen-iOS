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
    var state: State = .none
    var showSignUp: Bool = true

    // MARK: - Input
    public init(loginRequest: LoginRequest = LoginRequest()) {
        self.loginRequest = loginRequest
        self.tokenHelper.delegate = self
    }

    public func login() {
        if UserManager.shared.role == "guest" {
            self.loginWithEmail()
        } else {
            self.guestLogin()
        }
    }

    private func loginWithEmail() {
        self.state = .login
        self.authenticationRepository.login(loginRequest: self.loginRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    UserHelper.shared.setupDataUserLogin(json: json)
                    self.sendAnalytics()
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

    private func guestLogin() {
        self.state = .guestLogin
        self.authenticationRepository.guestLogin(uuid: Defaults[.deviceUuid]) { (success) in
            if success {
                self.loginWithEmail()
            }
        }
    }

    private func sendAnalytics() {
        let item = Analytic()
        item.accountId = UserManager.shared.accountId
        item.userId = UserManager.shared.id
        item.channel = TrackingChennel.email.rawValue
        TrackingAnalyticHelper.shared.sendTrackingAnalytic(eventType: .login, item: item)
    }

    private func registerNotificationToken() {
        self.state = .registerToken
        self.notificationRequest.uuid = Defaults[.deviceUuid]
        self.notificationRequest.firebaseToken = Defaults[.firebaseToken]
        self.notificationRepository.registerToken(notificationRequest: self.notificationRequest) { (success, _, isRefreshToken) in
            if !success && isRefreshToken {
                self.tokenHelper.refreshToken()
            }
        }
    }
}

extension LoginViewModel: TokenHelperDelegate {
    func didRefreshTokenFinish() {
        if self.state == .login {
            self.login()
        } else if self.state == .registerToken {
            self.registerNotificationToken()
        }
    }
}
