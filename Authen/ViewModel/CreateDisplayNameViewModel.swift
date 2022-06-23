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
//  CreateDisplayNameViewModel.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 10/8/2564 BE.
//

import Core
import Networking
import Moya
import SwiftyJSON
import Defaults

public protocol CreateDisplayNameViewModelDelegate: AnyObject {
    func didRegisterFinish(success: Bool)
    func didCheckCastcleIdExistsFinish()
    func didSuggestCastcleIdFinish(suggestCastcleId: String)
}

public class CreateDisplayNameViewModel {
    public var delegate: CreateDisplayNameViewModelDelegate?
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    var notificationRepository: NotificationRepository = NotificationRepositoryImpl()
    var authenRequest: AuthenRequest = AuthenRequest()
    var notificationRequest: NotificationRequest = NotificationRequest()
    var isCastcleIdExist: Bool = true
    var isValidateCastcleId: Bool = false
    let tokenHelper: TokenHelper = TokenHelper()
    private var state: State = .none

    // MARK: - Input
    public init(authenRequest: AuthenRequest = AuthenRequest()) {
        self.authenRequest = authenRequest
        self.tokenHelper.delegate = self
    }

    public func suggestCastcleId() {
        self.state = .suggestCastcleId
        self.authenticationRepository.suggestCastcleId(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let payload = JSON(json[JsonKey.payload.rawValue].dictionaryValue)
                    let suggestCastcleId = payload[JsonKey.suggestCastcleId.rawValue].stringValue
                    self.delegate?.didSuggestCastcleIdFinish(suggestCastcleId: suggestCastcleId)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func checkCastcleIdExists() {
        self.state = .checkCastcleIdExists
        self.authenticationRepository.checkCastcleId(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let payload = JSON(json[JsonKey.payload.rawValue].dictionaryValue)
                    let exist = payload[JsonKey.exist.rawValue].boolValue
                    self.isCastcleIdExist = exist
                    self.delegate?.didCheckCastcleIdExistsFinish()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didCheckCastcleIdExistsFinish()
                }
            }
        }
    }

    public func register() {
        self.state = .register
        self.authenticationRepository.register(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    UserHelper.shared.setupDataUserLogin(json: json)
                    Defaults[.email] = self.authenRequest.email
                    AdjustHelper.shared.sendAdjustAnalytic(eventType: .registration, userId: UserManager.shared.id, chennel: .email)
                    self.registerNotificationToken()
                    self.delegate?.didRegisterFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didRegisterFinish(success: true)
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

extension CreateDisplayNameViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .suggestCastcleId {
            self.suggestCastcleId()
        } else if self.state == .checkCastcleIdExists {
            self.checkCastcleIdExists()
        } else if self.state == .register {
            self.register()
        } else if self.state == .registerToken {
            self.registerNotificationToken()
        }
    }
}
