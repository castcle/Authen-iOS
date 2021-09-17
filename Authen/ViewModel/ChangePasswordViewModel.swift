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
//  Created by Tanakorn Phoochaliaw on 1/9/2564 BE.
//

import Core
import Networking
import SwiftyJSON

public enum ChangePasswordType {
    case changePassword
    case forgotPassword
}

public protocol ChangePasswordViewModelDelegate {
    func didChangePasswordSubmitFinish(success: Bool)
}

public class ChangePasswordViewModel {
    public var delegate: ChangePasswordViewModelDelegate?
    
    var changePasswordType: ChangePasswordType = .changePassword
    var authenRequest: AuthenRequest
    var authenticationRepository: AuthenticationRepository
    let tokenHelper: TokenHelper = TokenHelper()
    
    init(_ changePasswordType: ChangePasswordType, authenRequest: AuthenRequest = AuthenRequest(), authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()) {
        self.changePasswordType = changePasswordType
        self.authenRequest = authenRequest
        self.authenticationRepository = authenticationRepository
        self.tokenHelper.delegate = self
    }
    
    public func changePasswordSubmit() {
        self.authenticationRepository.changePasswordSubmit(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                self.delegate?.didChangePasswordSubmitFinish(success: true)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didChangePasswordSubmitFinish(success: false)
                }
            }
        }
    }
}

extension ChangePasswordViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        self.changePasswordSubmit()
    }
}