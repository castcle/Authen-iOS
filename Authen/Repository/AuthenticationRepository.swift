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
//  AuthenticationRepository.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 3/8/2564 BE.
//

import Moya
import SwiftyJSON

protocol AuthenticationRepository {
    func login(loginRequest: LoginRequest, _ completion: @escaping (Bool) -> ())
    func checkEmailExists(authenRequest: AuthenRequest, _ completion: @escaping (Bool) -> ())
    func checkDisplayNameExists(authenRequest: AuthenRequest, _ completion: @escaping (Bool) -> ())
    func checkCastcleIdExists(authenRequest: AuthenRequest, _ completion: @escaping (Bool) -> ())
    func register(authenRequest: AuthenRequest, _ completion: @escaping (Bool) -> ())
    func requestLinkVerify(_ completion: @escaping (Bool) -> ())
}

final class AuthenticationRepositoryImpl: AuthenticationRepository {
    private let authenticationApi = MoyaProvider<AuthenticationApi>(stubClosure: MoyaProvider.delayedStub(1.0))
    
    func login(loginRequest: LoginRequest, _ completion: @escaping (Bool) -> ()) {
        self.authenticationApi.request(.login(loginRequest)) { result in
            switch result {
            case .success:
                print("Success")
            case .failure:
                print("Failure")
            }
        }
    }
    
    func checkEmailExists(authenRequest: AuthenRequest, _ completion: @escaping (Bool) -> ()) {
        self.authenticationApi.request(.checkEmailExists(authenRequest)) { result in
            switch result {
            case .success:
                print("Success")
            case .failure:
                print("Failure")
            }
        }
    }
    
    func checkDisplayNameExists(authenRequest: AuthenRequest, _ completion: @escaping (Bool) -> ()) {
        self.authenticationApi.request(.checkDisplayNameExists(authenRequest)) { result in
            switch result {
            case .success:
                print("Success")
            case .failure:
                print("Failure")
            }
        }
    }
    
    func checkCastcleIdExists(authenRequest: AuthenRequest, _ completion: @escaping (Bool) -> ()) {
        self.authenticationApi.request(.checkCastcleIdExists(authenRequest)) { result in
            switch result {
            case .success:
                print("Success")
            case .failure:
                print("Failure")
            }
        }
    }
    
    func register(authenRequest: AuthenRequest, _ completion: @escaping (Bool) -> ()) {
        self.authenticationApi.request(.register(authenRequest)) { result in
            switch result {
            case .success:
                print("Success")
            case .failure:
                print("Failure")
            }
        }
    }
    
    func requestLinkVerify(_ completion: @escaping (Bool) -> ()) {
        self.authenticationApi.request(.requestLinkVerify) { result in
            switch result {
            case .success:
                print("Success")
            case .failure:
                print("Failure")
            }
        }
    }
}
