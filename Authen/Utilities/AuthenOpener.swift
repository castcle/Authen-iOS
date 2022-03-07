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
//  AuthenOpener.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 28/7/2564 BE.
//

import UIKit
import Core

public enum AuthenScene {
    case signUpMethod
    case signIn(showSignUp: Bool)
    case email(fromSignIn: Bool)
    case createPassword
    case createDisplayName
    case verifyEmail
    case resendEmail(ResendEmailViewModel)
    case oldPassword
    case changePassword(ChangePasswordViewModel)
    case changePasswordSuccess(ChangePasswordViewModel)
    case checkEmail
    case forgotPassword
    case enterCode(EnterCodeViewModel)
    case mergeAccount(MergeAccountViewModel)
    case mergeAccountSuccess
}

public struct AuthenOpener {
    public static func open(_ authenScene: AuthenScene) -> UIViewController {
        switch authenScene {
        case .signUpMethod:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.signUpMethod)
            return vc
        case .signIn(let showSignUp):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.signIn) as? SignInViewController
            vc?.showSignUp = showSignUp
            return vc ?? SignInViewController()
        case .email(let fromSignIn):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.email) as? EmailViewController
            vc?.fromSignIn = fromSignIn
            return vc ?? EmailViewController()
        case .createPassword:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.createPassword)
            return vc
        case .createDisplayName:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.createDisplayName)
            return vc
        case .verifyEmail:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.verifyEmail)
            return vc
        case .resendEmail(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.resendEmail) as? ResendEmailViewController
            vc?.viewModel = viewModel
            return vc ?? ResendEmailViewController()
        case .oldPassword:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.password, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.oldPassword)
            return vc
        case .changePassword(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.password, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.changePassword) as? ChangePasswordViewController
            vc?.viewModel = viewModel
            return vc ?? ChangePasswordViewController()
        case .changePasswordSuccess(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.password, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.changePasswordSuccess) as? ChangePasswordSuccessViewController
            vc?.viewModel = viewModel
            return vc ?? ChangePasswordSuccessViewController()
        case .checkEmail:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.password, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.checkEmail)
            return vc
        case .forgotPassword:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.password, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.forgotPassword)
            return vc
        case .enterCode(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.password, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.enterCode) as? EnterCodeViewController
            vc?.viewModel = viewModel
            return vc ?? EnterCodeViewController()
        case .mergeAccount(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.mergeAccount) as? MergeAccountViewController
            vc?.viewModel = viewModel
            return vc ?? MergeAccountViewController()
        case .mergeAccountSuccess:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.mergeAccountSuccess) as? MergeAccountSuccessViewController
            return vc ?? MergeAccountSuccessViewController()
        }
    }
}
