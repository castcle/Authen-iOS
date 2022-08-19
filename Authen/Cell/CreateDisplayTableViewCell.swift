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
import Component
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

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .head4)
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
        self.castcleIdView.capsule(color: UIColor.Asset.cellBackground)
        self.displayNameView.capsule(color: UIColor.Asset.cellBackground)
        self.castcleIdTextField.tag = 0
        self.castcleIdTextField.delegate = self
        self.castcleIdTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.displayNameTextField.delegate = self
        self.displayNameTextField.tag = 1
        self.displayNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.castcleIdAlertLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.castcleIdAlertLabel.textColor = UIColor.Asset.denger
        self.castcleIdAlertLabel.isHidden = true
        self.nextButton.activeButton(isActive: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(viewModel: CreateDisplayNameViewModel) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }

    private func updateUI() {
        if self.viewModel.isCastcleIdExist {
            self.nextButton.activeButton(isActive: false)
            self.castcleIdAlertLabel.isHidden = false
            self.castcleIdAlertLabel.text = "Castcle ID has been taken."
        } else {
            if self.displayNameTextField.text!.isEmpty {
                self.nextButton.activeButton(isActive: false)
            } else {
                self.nextButton.activeButton(isActive: true)
            }
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
            let rawCastcleId = displayCastcleId.toRawCastcleId
            if displayCastcleId == "@" {
                self.castcleIdAlertLabel.isHidden = true
            } else if !rawCastcleId.isEmpty {
                let castcleId = rawCastcleId.toCastcleId
                if castcleId.count > 30 {
                    self.castcleIdAlertLabel.isHidden = false
                    self.castcleIdAlertLabel.text = "Castcle ID cannot exceed 30 characters"
                } else if !castcleId.isCastcleId {
                    self.castcleIdAlertLabel.isHidden = false
                    self.castcleIdAlertLabel.text = "Castcle ID cannot contain special characters"
                } else {
                    self.castcleIdAlertLabel.isHidden = true
                }
                textField.text = castcleId
            } else {
                textField.text = ""
                self.castcleIdAlertLabel.isHidden = true
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.nextButton.activeButton(isActive: false)
        if textField.tag == 0 {
            self.castcleIdAlertLabel.isHidden = true
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            let displayName = textField.text ?? ""
            self.viewModel.authenRequest.displayName = displayName
            if !self.viewModel.authenRequest.displayName.isEmpty && !self.viewModel.isCastcleIdExist {
                self.nextButton.activeButton(isActive: true)
            } else if !self.viewModel.authenRequest.displayName.isEmpty && self.viewModel.isCastcleIdExist {
                CCLoading.shared.show(text: "Loading")
                self.castcleIdTextField.isEnabled = false
                self.displayNameTextField.isEnabled = false
                self.viewModel.suggestCastcleId()
            } else {
                self.nextButton.activeButton(isActive: false)
            }
        } else if textField.tag == 0 {
            let idCastcle = textField.text ?? ""
            if idCastcle.isEmpty || idCastcle == "@" {
                self.viewModel.isCastcleIdExist = true
                self.nextButton.activeButton(isActive: false)
            } else {
                CCLoading.shared.show(text: "Checking")
                self.viewModel.authenRequest.castcleId = textField.text!.toCastcleId
                self.castcleIdTextField.isEnabled = false
                self.displayNameTextField.isEnabled = false
                self.viewModel.checkCastcleIdExists()
            }
        }
    }

    @IBAction func nextAction(_ sender: Any) {
        self.endEditing(true)
        if self.viewModel.authenRequest.castcleId.isCastcleId && !self.viewModel.isCastcleIdExist && self.viewModel.authenRequest.castcleId.count <= 30 && !self.viewModel.authenRequest.displayName.isEmpty {
            CCLoading.shared.show(text: "Creating")
            self.viewModel.register()
        }
    }
}

extension CreateDisplayTableViewCell: CreateDisplayNameViewModelDelegate {
    func didSuggestCastcleIdFinish(suggestCastcleId: String) {
        let castcleId = suggestCastcleId.toCastcleId
        CCLoading.shared.dismiss()
        self.viewModel.authenRequest.castcleId = castcleId
        self.viewModel.isCastcleIdExist = false
        self.castcleIdTextField.isEnabled = true
        self.displayNameTextField.isEnabled = true
        self.castcleIdTextField.text = castcleId
        self.updateUI()
    }

    func didCheckCastcleIdExistsFinish() {
        CCLoading.shared.dismiss()
        self.castcleIdTextField.isEnabled = true
        self.displayNameTextField.isEnabled = true
        self.updateUI()
    }

    func didRegisterFinish(success: Bool) {
        CCLoading.shared.dismiss()
        if success {
            Defaults[.startLoadFeed] = true
            NotificationCenter.default.post(name: .updateProfileDelegate, object: nil)
        }
    }
}
