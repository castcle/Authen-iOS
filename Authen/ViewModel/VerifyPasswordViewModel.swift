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
//  VerifyPasswordViewModel.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 12/9/2564 BE.
//

import Core
import Networking
import SwiftyJSON

public protocol VerifyPasswordViewModelDelegate: AnyObject {
    func didVerificationPasswordFinish(success: Bool)
}

class VerifyPasswordViewModel {

    public var delegate: VerifyPasswordViewModelDelegate?
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    var authenRequest: AuthenRequest = AuthenRequest()
    let tokenHelper: TokenHelper = TokenHelper()

    // MARK: - Input
    public init() {
        self.tokenHelper.delegate = self
    }

    public func verifyPassword() {
        self.authenRequest.objective = .changePassword
        self.authenticationRepository.verifyPassword(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.authenRequest.payload.refCode = json[JsonKey.refCode.rawValue].stringValue
                    self.delegate?.didVerificationPasswordFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didVerificationPasswordFinish(success: false)
                }
            }
        }
    }
}

extension VerifyPasswordViewModel: TokenHelperDelegate {
    func didRefreshTokenFinish() {
        self.verifyPassword()
    }
}
