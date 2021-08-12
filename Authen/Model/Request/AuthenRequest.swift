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
//  AuthenRequest.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 3/8/2564 BE.
//

public enum AuthenChannelKey: String {
    case mobile
    case email
}

public struct AuthenRequest {
    enum AuthenRequestKey: String {
        case channel
        case payload
    }
    
    public var channel: AuthenChannelKey
    public var payload: AuthenPayloadRequest
    
    init() {
        self.channel = .email
        self.payload = AuthenPayloadRequest()
    }
    
    public var paramRegister: [String: Any] {
        return [
            AuthenRequestKey.channel.rawValue: self.channel.rawValue,
            AuthenRequestKey.payload.rawValue: self.payload.param
        ]
    }
}

public struct AuthenPayloadRequest {
    enum AuthenPayloadKey: String {
        case email
        case password
        case countryCode
        case mobileNumber
        case displayName
        case castcleId
    }
    
    public var email: String
    public var password: String
    public var countryCode: String
    public var mobileNumber: String
    public var displayName: String
    public var castcleId: String
    
    init() {
        self.email = ""
        self.password = ""
        self.countryCode = ""
        self.mobileNumber = ""
        self.displayName = ""
        self.castcleId = ""
    }
    
    public var paramCheckEmailExists: [String: Any] {
        return [
            AuthenPayloadKey.email.rawValue: self.email
        ]
    }
    
    public var paramCheckDisplayNameExists: [String: Any] {
        return [
            AuthenPayloadKey.displayName.rawValue: self.displayName
        ]
    }
    
    public var paramCheckCastcleIdExists: [String: Any] {
        return [
            AuthenPayloadKey.castcleId.rawValue: self.castcleId
        ]
    }
    
    public var param: [String: Any] {
        return [
            AuthenPayloadKey.email.rawValue: self.email,
            AuthenPayloadKey.password.rawValue: self.password,
            AuthenPayloadKey.countryCode.rawValue: self.countryCode,
            AuthenPayloadKey.mobileNumber.rawValue: self.mobileNumber,
            AuthenPayloadKey.displayName.rawValue: self.displayName,
            AuthenPayloadKey.castcleId.rawValue: self.castcleId
        ]
    }
}
