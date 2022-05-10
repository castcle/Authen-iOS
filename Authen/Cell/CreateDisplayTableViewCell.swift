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
//  CreateDisplayTableViewCell.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 9/5/2565 BE.
//

import UIKit
import Core
import JGProgressHUD
import Defaults

class CreateDisplayTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var castcleIdLabel: UILabel!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var castcleIdView: UIView!
    @IBOutlet var displayNameView: UIView!
    @IBOutlet var castcleIdTextField: UITextField!
    @IBOutlet var displayNameTextField: UITextField!
    @IBOutlet var castcleIdAlertLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    
    private var viewModel = CreateDisplayNameViewModel()
    let hud = JGProgressHUD()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.titleLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.castcleIdLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.castcleIdLabel.textColor = UIColor.Asset.white
        self.displayNameLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.castcleIdTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.castcleIdTextField.textColor = UIColor.Asset.white
        self.displayNameTextField.font = UIFont.asset(.regular, fontSize: .overline)
        self.displayNameTextField.textColor = UIColor.Asset.white
        self.castcleIdView.capsule(color: UIColor.Asset.darkGray)
        self.displayNameView.capsule(color: UIColor.Asset.darkGray)
    
        self.castcleIdTextField.tag = 0
        self.castcleIdTextField.delegate = self
        self.castcleIdTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.displayNameTextField.delegate = self
        self.displayNameTextField.tag = 1
        self.displayNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

        self.castcleIdAlertLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.castcleIdAlertLabel.textColor = UIColor.Asset.denger
        self.castcleIdAlertLabel.isHidden = true
        self.setupNextButton(isActive: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(viewModel: CreateDisplayNameViewModel) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    private func castcleId(displayCastcleId: String) -> String {
        return displayCastcleId.replacingOccurrences(of: "@", with: "")
    }
    
    private func updateUI() {
        if self.viewModel.isCastcleIdExist {
            self.setupNextButton(isActive: false)
            self.castcleIdAlertLabel.isHidden = false
            self.castcleIdAlertLabel.text = "Castcle ID has been taken."
        } else {
            self.castcleIdAlertLabel.isHidden = true
            if self.displayNameTextField.text!.isEmpty {
                self.setupNextButton(isActive: false)
            } else {
                self.setupNextButton(isActive: true)
            }
        }
    }
    
    private func setupNextButton(isActive: Bool) {
        self.nextButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        if isActive {
            self.nextButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.nextButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.nextButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.nextButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.displayNameTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0 {
            let displayCastcleId = textField.text ?? ""
            let castcleId = self.castcleId(displayCastcleId: displayCastcleId)
            if !castcleId.isEmpty {
                if castcleId.count > 30 {
                    self.castcleIdAlertLabel.isHidden = false
                    self.castcleIdAlertLabel.text = "Castcle ID cannot exceed 30 characters"
                } else if !castcleId.isCastcleId {
                    self.castcleIdAlertLabel.isHidden = false
                    self.castcleIdAlertLabel.text = "Castcle ID cannot contain special characters"
                } else {
                    self.castcleIdAlertLabel.isHidden = true
                }
                textField.text = "@\(castcleId)"
            } else {
                textField.text = ""
                self.castcleIdAlertLabel.isHidden = true
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setupNextButton(isActive: false)
        if textField.tag == 0 {
            self.castcleIdAlertLabel.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            let displayName = textField.text ?? ""
            self.viewModel.authenRequest.payload.displayName = displayName
            if !self.viewModel.authenRequest.payload.displayName.isEmpty && !self.viewModel.isCastcleIdExist {
                self.setupNextButton(isActive: true)
            } else if !self.viewModel.authenRequest.payload.displayName.isEmpty && self.viewModel.isCastcleIdExist {
                self.hud.textLabel.text = "Loading"
                self.hud.show(in: Utility.currentViewController().view)
                self.castcleIdTextField.isEnabled = false
                self.displayNameTextField.isEnabled = false
                self.viewModel.suggestCastcleId()
            } else {
                self.setupNextButton(isActive: false)
            }
        } else if textField.tag == 0 {
            let idCastcle = textField.text ?? ""
            if idCastcle.isEmpty {
                self.setupNextButton(isActive: false)
            } else {
                self.hud.textLabel.text = "Checking"
                self.hud.show(in: Utility.currentViewController().view)
                self.viewModel.authenRequest.payload.castcleId = self.castcleId(displayCastcleId: textField.text!)
                self.castcleIdTextField.isEnabled = false
                self.displayNameTextField.isEnabled = false
                self.viewModel.checkCastcleIdExists()
            }
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.endEditing(true)
        if self.viewModel.authenRequest.payload.castcleId.isCastcleId && !self.viewModel.isCastcleIdExist && self.viewModel.authenRequest.payload.castcleId.count <= 30 && !self.viewModel.authenRequest.payload.displayName.isEmpty {
            self.hud.textLabel.text = "Creating"
            self.hud.show(in: Utility.currentViewController().view)
            self.viewModel.register()
        }
    }
}

extension CreateDisplayTableViewCell: CreateDisplayNameViewModelDelegate {
    func didSuggestCastcleIdFinish(suggestCastcleId: String) {
        self.hud.dismiss()
        self.viewModel.authenRequest.payload.castcleId = suggestCastcleId
        self.viewModel.isCastcleIdExist = false
        self.castcleIdTextField.isEnabled = true
        self.displayNameTextField.isEnabled = true
        self.castcleIdTextField.text = "@\(suggestCastcleId)"
        self.updateUI()
    }
    
    func didCheckCastcleIdExistsFinish() {
        self.hud.dismiss()
        self.castcleIdTextField.isEnabled = true
        self.displayNameTextField.isEnabled = true
        self.updateUI()
    }
    
    func didRegisterFinish(success: Bool) {
        self.hud.dismiss()
        if success {
            Defaults[.startLoadFeed] = true
            NotificationCenter.default.post(name: .updateProfileDelegate, object: nil)
        }
    }
}