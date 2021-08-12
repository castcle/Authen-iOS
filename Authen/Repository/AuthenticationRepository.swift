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

import Core
import Moya
import SwiftyJSON
import Defaults

protocol AuthenticationRepository {
    func login(loginRequest: LoginRequest, _ completion: @escaping (Bool) -> ())
    func checkEmailExists(authenRequest: AuthenRequest, _ completion: @escaping (Bool, Bool) -> ())
    func checkCastcleIdExists(authenRequest: AuthenRequest, _ completion: @escaping (Bool, Bool) -> ())
    func register(authenRequest: AuthenRequest, _ completion: @escaping (Bool) -> ())
    func verificationEmail(_ completion: @escaping (Bool) -> ())
    func requestLinkVerify(_ completion: @escaping (Bool) -> ())
}

final class AuthenticationRepositoryImpl: AuthenticationRepository {
    private let authenticationApi = MoyaProvider<AuthenticationApi>()
    
    enum AuthenticationApiKey: String {
        case accessToken
        case refreshToken
        case exist
        case payload
    }
    
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
    
    func checkEmailExists(authenRequest: AuthenRequest, _ completion: @escaping (Bool, Bool) -> ()) {
        self.authenticationApi.request(.checkEmailExists(authenRequest)) { result in
            switch result {
            case .success(let response):
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    if response.statusCode < 300 {
                        let payload = JSON(json[AuthenticationApiKey.payload.rawValue].dictionaryValue)
                        let exist = payload[AuthenticationApiKey.exist.rawValue].boolValue
                        completion(true, exist)
                    } else {
                        ApiHelper.displayError(error: "\(json[ResponseErrorKey.code.rawValue].stringValue) : \(json[ResponseErrorKey.message.rawValue].stringValue)")
                        completion(false, false)
                    }
                } catch {
                    ApiHelper.displayError(error: "Something Went wrong")
                    completion(false, false)
                }
            case .failure:
                ApiHelper.displayError(error: "Something Went wrong")
                completion(false, false)
            }
        }
    }
    
    func checkCastcleIdExists(authenRequest: AuthenRequest, _ completion: @escaping (Bool, Bool) -> ()) {
        self.authenticationApi.request(.checkCastcleIdExists(authenRequest)) { result in
            switch result {
            case .success(let response):
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    if response.statusCode < 300 {
                        let payload = JSON(json[AuthenticationApiKey.payload.rawValue].dictionaryValue)
                        let exist = payload[AuthenticationApiKey.exist.rawValue].boolValue
                        completion(true, exist)
                    } else {
                        ApiHelper.displayError(error: "\(json[ResponseErrorKey.code.rawValue].stringValue) : \(json[ResponseErrorKey.message.rawValue].stringValue)")
                        completion(false, false)
                    }
                } catch {
                    ApiHelper.displayError(error: "Something Went wrong")
                    completion(false, false)
                }
            case .failure:
                ApiHelper.displayError(error: "Something Went wrong")
                completion(false, false)
            }
        }
    }
    
    func register(authenRequest: AuthenRequest, _ completion: @escaping (Bool) -> ()) {
        self.authenticationApi.request(.register(authenRequest)) { result in
            switch result {
            case .success(let response):
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    if response.statusCode < 300 {
                        let accessToken = json[AuthenticationApiKey.accessToken.rawValue].stringValue
                        let refreshToken = json[AuthenticationApiKey.refreshToken.rawValue].stringValue
                        Defaults[.userRole] = "USER"
                        Defaults[.accessToken] = accessToken
                        Defaults[.refreshToken] = refreshToken
                        completion(true)
                    } else {
                        ApiHelper.displayError(error: "\(json[ResponseErrorKey.code.rawValue].stringValue) : \(json[ResponseErrorKey.message.rawValue].stringValue)")
                        completion(false)
                    }
                } catch {
                    ApiHelper.displayError(error: "Something Went wrong")
                    completion(false)
                }
            case .failure:
                ApiHelper.displayError(error: "Something Went wrong")
                completion(false)
            }
        }
    }
    
    func verificationEmail(_ completion: @escaping (Bool) -> ()) {
        self.authenticationApi.request(.requestLinkVerify) { result in
            switch result {
            case .success(let response):
                do {
                    if response.statusCode < 204 {
                        completion(true)
                    }
                    
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    if response.statusCode < 300 {
                        completion(true)
                    } else {
                        ApiHelper.displayError(error: "\(json[ResponseErrorKey.code.rawValue].stringValue) : \(json[ResponseErrorKey.message.rawValue].stringValue)")
                        completion(false)
                    }
                } catch {
                    ApiHelper.displayError(error: "Something Went wrong")
                    completion(false)
                }
            case .failure:
                ApiHelper.displayError(error: "Something Went wrong")
                completion(false)
            }
        }
    }
    
    func requestLinkVerify(_ completion: @escaping (Bool) -> ()) {
        self.authenticationApi.request(.requestLinkVerify) { result in
            switch result {
            case .success(let response):
                do {
                    if response.statusCode < 204 {
                        completion(true)
                    }
                    
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    if response.statusCode < 300 {
                        completion(true)
                    } else {
                        ApiHelper.displayError(error: "\(json[ResponseErrorKey.code.rawValue].stringValue) : \(json[ResponseErrorKey.message.rawValue].stringValue)")
                        completion(false)
                    }
                } catch {
                    ApiHelper.displayError(error: "Something Went wrong")
                    completion(false)
                }
            case .failure:
                ApiHelper.displayError(error: "Something Went wrong")
                completion(false)
            }
        }
    }
}
