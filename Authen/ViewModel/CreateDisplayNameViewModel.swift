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

public protocol CreateDisplayNameViewModelDelegate {
    func didRegisterFinish(success: Bool)
    func didCheckCastcleIdExistsFinish()
    func didSuggestCastcleIdFinish(suggestCastcleId: String)
}

class CreateDisplayNameViewModel {
    
    public var delegate: CreateDisplayNameViewModelDelegate?
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    var notificationRepository: NotificationRepository = NotificationRepositoryImpl()
    var authenRequest: AuthenRequest = AuthenRequest()
    var notificationRequest: NotificationRequest = NotificationRequest()
    var isCastcleIdExist: Bool = true
    let tokenHelper: TokenHelper = TokenHelper()
    private var stage: CreateDisplayNameStage = .none
    
    enum CreateDisplayNameStage {
        case suggest
        case check
        case register
        case registerToken
        case none
    }

    //MARK: Input
    public init(authenRequest: AuthenRequest = AuthenRequest()) {
        self.authenRequest = authenRequest
        self.tokenHelper.delegate = self
    }
    
    public func suggestCastcleId() {
        self.stage = .suggest
        self.authenticationRepository.suggestCastcleId(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let payload = JSON(json[AuthenticationApiKey.payload.rawValue].dictionaryValue)
                    let suggestCastcleId = payload[AuthenticationApiKey.suggestCastcleId.rawValue].stringValue
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
        self.stage = .check
        self.authenticationRepository.checkCastcleIdExists(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let payload = JSON(json[AuthenticationApiKey.payload.rawValue].dictionaryValue)
                    let exist = payload[AuthenticationApiKey.exist.rawValue].boolValue
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
        self.stage = .register
        self.authenticationRepository.register(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let accessToken = json[AuthenticationApiKey.accessToken.rawValue].stringValue
                    let refreshToken = json[AuthenticationApiKey.refreshToken.rawValue].stringValue
                    let profile = JSON(json[AuthenticationApiKey.profile.rawValue].dictionaryValue)
                    
                    let userHelper = UserHelper()
                    userHelper.updateLocalProfile(user: UserInfo(json: profile))
                    userHelper.clearSeenContent()
                    UserManager.shared.setUserRole(userRole: .user)
                    UserManager.shared.setAccessToken(token: accessToken)
                    UserManager.shared.setRefreshToken(token: refreshToken)
                    Defaults[.email] = self.authenRequest.payload.email
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
        self.stage = .registerToken
        self.notificationRequest.deviceUUID = Defaults[.deviceUuid]
        self.notificationRequest.firebaseToken = Defaults[.firebaseToken]
        self.notificationRepository.registerToken(notificationRequest: self.notificationRequest) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
}

extension CreateDisplayNameViewModel: TokenHelperDelegate {
    func didRefreshTokenFinish() {
        if self.stage == .suggest {
            self.suggestCastcleId()
        } else if self.stage == .check {
            self.checkCastcleIdExists()
        } else if self.stage == .register {
            self.register()
        } else if self.stage == .registerToken {
            self.registerNotificationToken()
        }
    }
}
