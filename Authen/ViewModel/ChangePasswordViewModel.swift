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
//  ChangePasswordViewModel.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 1/9/2564 BE.
//

import Core
import Networking
import SwiftyJSON

public enum ChangePasswordType {
    case changePassword
    case forgotPassword
    case createPassword
}

public protocol ChangePasswordViewModelDelegate: AnyObject {
    func didChangePasswordSubmitFinish(success: Bool)
}

public class ChangePasswordViewModel {
    public var delegate: ChangePasswordViewModelDelegate?
    var changePasswordType: ChangePasswordType = .changePassword
    var authenRequest: AuthenRequest
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    var userRepository: UserRepository = UserRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var state: State = .none

    public init(_ changePasswordType: ChangePasswordType, authenRequest: AuthenRequest = AuthenRequest()) {
        self.changePasswordType = changePasswordType
        self.authenRequest = authenRequest
        self.tokenHelper.delegate = self
    }

    public func changePassword() {
        self.state = .updatePassword
        self.authenticationRepository.changePassword(authenRequest: self.authenRequest) { (success, _, isRefreshToken) in
            if success {
                if self.changePasswordType == .createPassword {
                    self.getMe()
                } else {
                    self.delegate?.didChangePasswordSubmitFinish(success: true)
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didChangePasswordSubmitFinish(success: false)
                }
            }
        }
    }

    private func getMe() {
        self.state = .getMe
        self.userRepository.getMe { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    UserHelper.shared.updateLocalProfile(user: UserInfo(json: json))
                    self.delegate?.didChangePasswordSubmitFinish(success: true)
                } catch {
                    self.delegate?.didChangePasswordSubmitFinish(success: true)
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didChangePasswordSubmitFinish(success: true)
                }
            }
        }
    }
}

extension ChangePasswordViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .updatePassword {
            self.changePassword()
        } else if self.state == .getMe {
            self.getMe()
        }
    }
}
