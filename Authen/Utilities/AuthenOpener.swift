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
//  Created by Tanakorn Phoochaliaw on 28/7/2564 BE.
//

import UIKit
import Core

public enum AuthenScene {
    case signUpMethod
    case signIn
    case email
    case createPassword
    case createDisplayName
    case verifyEmail
}

public struct AuthenOpener {
    public static func open(_ authenScene: AuthenScene) -> UIViewController {
        switch authenScene {
        case .signUpMethod:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.signUpMethod)
            return vc
        case .signIn:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.signIn)
            return vc
        case .email:
            let storyboard: UIStoryboard = UIStoryboard(name: AuthenNibVars.Storyboard.authen, bundle: ConfigBundle.authen)
            let vc = storyboard.instantiateViewController(withIdentifier: AuthenNibVars.ViewController.email)
            return vc
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
        }
    }
}
