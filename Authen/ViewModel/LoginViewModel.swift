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
//  Created by Tanakorn Phoochaliaw on 10/9/2564 BE.
//

import Core
import Networking
import SwiftyJSON
import Defaults

public protocol LoginViewModelDelegate {
    func didLoginFinish(success: Bool)
}

class LoginViewModel {
    
    public var delegate: LoginViewModelDelegate?
    
    //MARK: Private
    var authenticationRepository: AuthenticationRepository
    var loginRequest: LoginRequest = LoginRequest()
    let tokenViewModel: TokenViewModel = TokenViewModel()

    //MARK: Input
    public init(loginRequest: LoginRequest = LoginRequest(), authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()) {
        self.loginRequest = loginRequest
        self.authenticationRepository = authenticationRepository
        self.tokenViewModel.delegate = self
    }
    
    public func login() {
        self.authenticationRepository.login(loginRequest: self.loginRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let accessToken = json[AuthenticationApiKey.accessToken.rawValue].stringValue
                    let refreshToken = json[AuthenticationApiKey.refreshToken.rawValue].stringValue
                    Defaults[.userRole] = "USER"
                    Defaults[.accessToken] = accessToken
                    Defaults[.refreshToken] = refreshToken
                    self.delegate?.didLoginFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenViewModel.refreshToken()
                } else {
                    self.delegate?.didLoginFinish(success: false)
                }
            }
        }
    }
}

extension LoginViewModel: TokenViewModelDelegate {
    func didRefreshTokenFinish() {
        self.login()
    }
}
