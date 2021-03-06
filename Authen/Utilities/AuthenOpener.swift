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
    case signIn
    case signUp
    case createDisplayName(CreateDisplayNameViewModel)
    case resendEmail(ResendEmailViewModel)
    case oldPassword
    case changePassword(ChangePasswordViewModel)
    case changePasswordSuccess(ChangePasswordViewModel)
    case checkEmail
    case enterCode(EnterCodeViewModel)
    case mergeAccount(MergeAccountViewModel)
    case mergeAccountSuccess
}

public struct AuthenOpener {
    public static func open(_ authenScene: AuthenScene) -> UIViewController {
        switch authenScene {
        case .signIn:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let viewController = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.signIn) as? SignInViewController
            return viewController ?? SignInViewController()
        case .signUp:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let viewController = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.signUp) as? SignUpViewController
            return viewController ?? SignUpViewController()
        case .createDisplayName(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let viewController = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.createDisplayName) as? CreateDisplayNameViewController
            viewController?.viewModel = viewModel
            return viewController ?? CreateDisplayNameViewController()
        case .resendEmail(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let viewController = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.resendEmail) as? ResendEmailViewController
            viewController?.viewModel = viewModel
            return viewController ?? ResendEmailViewController()
        case .oldPassword:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.password, bundle: ConfigBundle.authen)
            let viewController = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.oldPassword)
            return viewController
        case .changePassword(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.password, bundle: ConfigBundle.authen)
            let viewController = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.changePassword) as? ChangePasswordViewController
            viewController?.viewModel = viewModel
            return viewController ?? ChangePasswordViewController()
        case .changePasswordSuccess(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.password, bundle: ConfigBundle.authen)
            let viewController = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.changePasswordSuccess) as? ChangePasswordSuccessViewController
            viewController?.viewModel = viewModel
            return viewController ?? ChangePasswordSuccessViewController()
        case .checkEmail:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.password, bundle: ConfigBundle.authen)
            let viewController = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.checkEmail)
            return viewController
        case .enterCode(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.password, bundle: ConfigBundle.authen)
            let viewController = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.enterCode) as? EnterCodeViewController
            viewController?.viewModel = viewModel
            return viewController ?? EnterCodeViewController()
        case .mergeAccount(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let viewController = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.mergeAccount) as? MergeAccountViewController
            viewController?.viewModel = viewModel
            return viewController ?? MergeAccountViewController()
        case .mergeAccountSuccess:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let viewController = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.mergeAccountSuccess) as? MergeAccountSuccessViewController
            return viewController ?? MergeAccountSuccessViewController()
        }
    }
}
