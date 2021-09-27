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
//  Localizable.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 27/9/2564 BE.
//

import Core

extension Localization {
    
    // MARK: - Authen Method
    public enum AuthenMethod {
        case title
        case subtitle
        case subtitleUserAgreement
        case subtitleAnd
        case subtitlePrivacyPolicy
        case telegram
        case facebook
        case twitter
        case google
        case apple
        case email
        case alreadyAccount
        case login
        case joinUs
        case docs
        case whitepaper
        case version
        
        public var text: String {
            switch self {
            case .title:
                return "authen_method_title".localized(bundle: ConfigBundle.authen)
            case .subtitle:
                return "authen_method_subtitle".localized(bundle: ConfigBundle.authen)
            case .subtitleUserAgreement:
                return "authen_method_subtitle_user_agreement".localized(bundle: ConfigBundle.authen)
            case .subtitleAnd:
                return "authen_method_subtitle_and".localized(bundle: ConfigBundle.authen)
            case .subtitlePrivacyPolicy:
                return "authen_method_subtitle_privacy_policy".localized(bundle: ConfigBundle.authen)
            case .telegram:
                return "authen_method_telegram".localized(bundle: ConfigBundle.authen)
            case .facebook:
                return "authen_method_facebook".localized(bundle: ConfigBundle.authen)
            case .twitter:
                return "authen_method_twitter".localized(bundle: ConfigBundle.authen)
            case .google:
                return "authen_method_google".localized(bundle: ConfigBundle.authen)
            case .apple:
                return "authen_method_apple".localized(bundle: ConfigBundle.authen)
            case .email:
                return "authen_method_email".localized(bundle: ConfigBundle.authen)
            case .alreadyAccount:
                return "authen_method_already_account".localized(bundle: ConfigBundle.authen)
            case .login:
                return "authen_method_login".localized(bundle: ConfigBundle.authen)
            case .joinUs:
                return "authen_method_join_us".localized(bundle: ConfigBundle.authen)
            case .docs:
                return "authen_method_docs".localized(bundle: ConfigBundle.authen)
            case .whitepaper:
                return "authen_method_whitepaper".localized(bundle: ConfigBundle.authen)
            case .version:
                return "authen_method_version".localized(bundle: ConfigBundle.authen)
            }
        }
    }
    
    // MARK: - Login
    public enum Login {
        case title
        case welcome
        case castcle
        case email
        case password
        case forgotPassword
        case button
        case newUser
        case signUp
        
        public var text: String {
            switch self {
            case .title:
                return "login_title".localized(bundle: ConfigBundle.authen)
            case .welcome:
                return "login_welcome".localized(bundle: ConfigBundle.authen)
            case .castcle:
                return "login_castcle".localized(bundle: ConfigBundle.authen)
            case .email:
                return "login_email".localized(bundle: ConfigBundle.authen)
            case .password:
                return "login_password".localized(bundle: ConfigBundle.authen)
            case .forgotPassword:
                return "login_forgot_password".localized(bundle: ConfigBundle.authen)
            case .button:
                return "login_button".localized(bundle: ConfigBundle.authen)
            case .newUser:
                return "login_new_user".localized(bundle: ConfigBundle.authen)
            case .signUp:
                return "login_sign_up".localized(bundle: ConfigBundle.authen)
            }
        }
    }
    
    // MARK: - Register (Check Email)
    public enum RegisterCheckEmail {
        case title
        case headline
        case welcome
        case email
        case alertNotice
        case button
        case alreadyAccount
        case alertEmailInvalid
        case alertEmailValid
        case alertWrongFormat
        
        public var text: String {
            switch self {
            case .title:
                return "register_check_email_title".localized(bundle: ConfigBundle.authen)
            case .headline:
                return "register_check_email_headline".localized(bundle: ConfigBundle.authen)
            case .welcome:
                return "register_check_email_welcome".localized(bundle: ConfigBundle.authen)
            case .email:
                return "register_check_email_email".localized(bundle: ConfigBundle.authen)
            case .alertNotice:
                return "register_check_email_alert_notice".localized(bundle: ConfigBundle.authen)
            case .button:
                return "register_check_email_button".localized(bundle: ConfigBundle.authen)
            case .alreadyAccount:
                return "register_check_email_already_account".localized(bundle: ConfigBundle.authen)
            case .alertEmailInvalid:
                return "register_check_email_alert_email_invalid".localized(bundle: ConfigBundle.authen)
            case .alertEmailValid:
                return "register_check_email_alert_email_valid".localized(bundle: ConfigBundle.authen)
            case .alertWrongFormat:
                return "register_check_email_alert_wrong_format".localized(bundle: ConfigBundle.authen)
            }
        }
    }
    
    // MARK: - Register (Password)
    public enum RegisterPassword {
        case headline
        case subtitle
        case value
        case retry
        case notice
        case button
        
        public var text: String {
            switch self {
            case .headline:
                return "register_password_headline".localized(bundle: ConfigBundle.authen)
            case .subtitle:
                return "register_password_subtitle".localized(bundle: ConfigBundle.authen)
            case .value:
                return "register_password_value".localized(bundle: ConfigBundle.authen)
            case .retry:
                return "register_password_retry".localized(bundle: ConfigBundle.authen)
            case .notice:
                return "register_password_notice".localized(bundle: ConfigBundle.authen)
            case .button:
                return "register_password_button".localized(bundle: ConfigBundle.authen)
            }
        }
    }
    
    // MARK: - Register (Display Name)
    public enum RegisterDisplayName {
        case headline
        case subtitle
        case value
        case castcleId
        case button
        
        public var text: String {
            switch self {
            case .headline:
                return "register_display_name_headline".localized(bundle: ConfigBundle.authen)
            case .subtitle:
                return "register_display_name_subtitle".localized(bundle: ConfigBundle.authen)
            case .value:
                return "register_display_name_value".localized(bundle: ConfigBundle.authen)
            case .castcleId:
                return "register_display_name_castcle_id".localized(bundle: ConfigBundle.authen)
            case .button:
                return "register_display_name_button".localized(bundle: ConfigBundle.authen)
            }
        }
    }
    
    // MARK: - Verify Email
    public enum VerifyEmail {
        case title
        case subtitle
        case notice
        case resend
        case gotoFeed
        case gotoProfileSetting
        
        public var text: String {
            switch self {
            case .title:
                return "verify_email_title".localized(bundle: ConfigBundle.authen)
            case .subtitle:
                return "verify_email_subtitle".localized(bundle: ConfigBundle.authen)
            case .notice:
                return "verify_email_notice".localized(bundle: ConfigBundle.authen)
            case .resend:
                return "verify_email_resend".localized(bundle: ConfigBundle.authen)
            case .gotoFeed:
                return "verify_email_go_to_feed".localized(bundle: ConfigBundle.authen)
            case .gotoProfileSetting:
                return "verify_email_go_to_profile_setting".localized(bundle: ConfigBundle.authen)
            }
        }
    }

    // MARK: - Resend Email
    public enum ResendEmail {
        case title
        case noticeTitle
        case noticeDetail
        case button
        
        public var text: String {
            switch self {
            case .title:
                return "resend_email_title".localized(bundle: ConfigBundle.authen)
            case .noticeTitle:
                return "resend_email_notice_title".localized(bundle: ConfigBundle.authen)
            case .noticeDetail:
                return "resend_email_notice_detail".localized(bundle: ConfigBundle.authen)
            case .button:
                return "resend_email_button".localized(bundle: ConfigBundle.authen)
            }
        }
    }
}
