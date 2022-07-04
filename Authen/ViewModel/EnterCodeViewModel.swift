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
//  EnterCodeViewModel.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 17/9/2564 BE.
//

import Core
import Networking
import SwiftyJSON
import RealmSwift
import Defaults

public protocol EnterCodeViewModelDelegate: AnyObject {
    func enterCodeDidVerifyOtpFinish(success: Bool)
    func enterCodeDidRequestOtpFinish(success: Bool)
    func enterCodeDidError()
}

public class EnterCodeViewModel {
    public var delegate: EnterCodeViewModelDelegate?
    public var verifyCodeType: VerifyCodeType
    var authenRequest: AuthenRequest = AuthenRequest()
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    var notificationRepository: NotificationRepository = NotificationRepositoryImpl()
    var notificationRequest: NotificationRequest = NotificationRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    private var state: State = .none

    public init(verifyCodeType: VerifyCodeType, authenRequest: AuthenRequest = AuthenRequest()) {
        self.verifyCodeType = verifyCodeType
        self.authenRequest = authenRequest
        self.tokenHelper.delegate = self
    }

    func verifyOtpWithEmail() {
        self.state = .verifyOtpWithEmail
        self.authenticationRepository.verificationOtpWithEmail(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.authenRequest.refCode = json[JsonKey.refCode.rawValue].stringValue
                    if self.authenRequest.objective == .mergeAccount {
                        let accessToken = json[JsonKey.accessToken.rawValue].stringValue
                        UserManager.shared.setAccessToken(token: accessToken)
                        self.connectWithSocial()
                    } else {
                        self.delegate?.enterCodeDidVerifyOtpFinish(success: true)
                    }
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.enterCodeDidVerifyOtpFinish(success: false)
                }
            }
        }
    }

    func requestOtpWithEmail() {
        self.state = .requestOtpWithEmail
        self.authenticationRepository.requestOtpWithEmail(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.authenRequest.refCode = json[JsonKey.refCode.rawValue].stringValue
                    self.delegate?.enterCodeDidRequestOtpFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.enterCodeDidRequestOtpFinish(success: false)
                }
            }
        }
    }

    func connectWithSocial() {
        self.state = .connectSocial
        self.authenticationRepository.connectWithSocial(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    UserHelper.shared.setupDataUserLogin(json: json)
                    self.registerNotificationToken()
                    self.delegate?.enterCodeDidVerifyOtpFinish(success: true)
                } catch {
                    self.delegate?.enterCodeDidVerifyOtpFinish(success: false)
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.enterCodeDidVerifyOtpFinish(success: false)
                }
            }
        }
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

extension EnterCodeViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .verifyOtpWithEmail {
            self.verifyOtpWithEmail()
        } else if self.state == .requestOtpWithEmail {
            self.requestOtpWithEmail()
        } else if self.state == .connectSocial {
            self.connectWithSocial()
        } else if self.state == .registerToken {
            self.registerNotificationToken()
        }
    }
}
