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
//  MergeAccountViewModel.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 17/9/2564 BE.
//

import UIKit
import Core
import Networking
import SwiftyJSON

public protocol MergeAccountViewModelDelegate {
    func didRequestOtpFinish(success: Bool)
}

public class MergeAccountViewModel {
    
    public var delegate: MergeAccountViewModelDelegate?
    var userInfo: UserInfo = UserInfo()
    var authenRequest: AuthenRequest = AuthenRequest()
    var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    
    var icon: UIImage {
        switch self.authenRequest.provider {
        case .facebook:
            return UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        case .twitter:
            return UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        case .google:
            return UIImage.Asset.googleLogo
        case .apple:
            return UIImage.init(icon: .castcle(.apple), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        default:
            return UIImage()
        }
    }
    
    var color: UIColor {
        switch self.authenRequest.provider {
        case .facebook:
            return UIColor.Asset.facebook
        case .twitter:
            return UIColor.Asset.twitter
        case .google:
            return UIColor.Asset.white
        case .apple:
            return UIColor.Asset.apple
        default:
            return UIColor.clear
        }
    }
    
    public init(userInfo: UserInfo, authenRequest: AuthenRequest) {
        self.userInfo = userInfo
        self.authenRequest = authenRequest
        self.tokenHelper.delegate = self
    }
    
    func requestOtp() {
        self.authenticationRepository.requestOtp(authenRequest: self.authenRequest) { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.authenRequest.payload.refCode = json[JsonKey.refCode.rawValue].stringValue
                    self.delegate?.didRequestOtpFinish(success: true)
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.delegate?.didRequestOtpFinish(success: false)
                }
            }
        }
    }
}

extension MergeAccountViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        self.requestOtp()
    }
}
