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
//  AuthenticationApi.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 3/8/2564 BE.
//

import Core
import Moya

enum AuthenticationApi {
    case login(LoginRequest)
    case checkEmailExists(AuthenRequest)
    case checkDisplayNameExists(AuthenRequest)
    case checkCastcleIdExists(AuthenRequest)
    case register(AuthenRequest)
    case requestLinkVerify
}

extension AuthenticationApi: TargetType {
    var baseURL: URL {
        return URL(string: Environment.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/authentications/login"
        case .checkEmailExists:
            return "/authentications/checkEmailExists"
        case .checkDisplayNameExists:
            return "/authentications/checkDisplayNameExists"
        case .checkCastcleIdExists:
            return "/authentications/checkCastcleIdExists"
        case .register:
            return "/authentications/register"
        case .requestLinkVerify:
            return "/authentications/requestLinkVerify"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "{\"message\": \"success message\"}".dataEncoded
    }
    
    var task: Task {
        switch self {
        case .login(let loginRequest):
            return .requestParameters(parameters: loginRequest.paramLogin, encoding: JSONEncoding.default)
        case .checkEmailExists(let authenRequest):
            return .requestParameters(parameters: authenRequest.payload.paramCheckEmailExists, encoding: JSONEncoding.default)
        case .checkDisplayNameExists(let authenRequest):
            return .requestParameters(parameters: authenRequest.payload.paramCheckDisplayNameExists, encoding: JSONEncoding.default)
        case .checkCastcleIdExists(let authenRequest):
            return .requestParameters(parameters: authenRequest.payload.paramCheckCastcleIdExists, encoding: JSONEncoding.default)
        case .register(let authenRequest):
            return .requestParameters(parameters: authenRequest.paramRegister, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
