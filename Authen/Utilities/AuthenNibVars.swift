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
//  AuthenNibVars.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 28/7/2564 BE.
//

public struct AuthenNibVars {
    // MARK: - View Controller
    public struct ViewController {
        public static let signIn = "SignInViewController"
        public static let signUp = "SignUpViewController"
        public static let createDisplayName = "CreateDisplayNameViewController"
        public static let resendEmail = "ResendEmailViewController"
        public static let oldPassword = "OldPasswordViewController"
        public static let changePassword = "ChangePasswordViewController"
        public static let changePasswordSuccess = "ChangePasswordSuccessViewController"
        public static let checkEmail = "CheckEmailViewController"
        public static let enterCode = "EnterCodeViewController"
        public static let mergeAccount = "MergeAccountViewController"
        public static let mergeAccountSuccess = "MergeAccountSuccessViewController"
    }

    // MARK: - View
    public struct Storyboard {
        public static let authen = "Authen"
        public static let password = "Password"
    }

    // MARK: - TableViewCell
    public struct TableViewCell {
        public static let oldPassword = "OldPasswordTableViewCell"
        public static let changePassword = "ChangePasswordTableViewCell"
        public static let signIn = "SignInTableViewCell"
        public static let signUp = "SignUpTableViewCell"
        public static let createDisplay = "CreateDisplayTableViewCell"
        public static let verifyEmailOtp = "VerifyEmailOtpTableViewCell"
    }

    // MARK: - CollectionViewCell
    public struct CollectionViewCell {
    }
}
