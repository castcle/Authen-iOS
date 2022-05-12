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
//  VerifyEmailOtpTableViewCell.swift
//  Authen
//
//  Created by Castcle Co., Ltd. on 10/2/2565 BE.
//

import UIKit
import Core
import SVPinView

protocol VerifyEmailOtpTableViewCellDelegate: AnyObject {
    func didRequestOtp(_ cell: VerifyEmailOtpTableViewCell)
    func didConfirm(_ cell: VerifyEmailOtpTableViewCell, pin: String)
}

class VerifyEmailOtpTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var pinView: SVPinView!
    @IBOutlet var noticLabel: UILabel!
    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var resendButton: UIButton!
    @IBOutlet var confirmButton: UIButton!

    var delegate: VerifyEmailOtpTableViewCellDelegate?
    var secondsRemaining = 300
    var pin: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.titleLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.subTitleLabel.textColor = UIColor.Asset.white
        self.countdownLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.countdownLabel.textColor = UIColor.Asset.lightGray
        self.noticLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.noticLabel.textColor = UIColor.Asset.white
        self.resendButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .body)
        self.resendButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.pinView.backgroundColor = UIColor.clear
        self.pinView.pinLength = 6
        self.pinView.style = .underline
        self.pinView.interSpace = 20
        self.pinView.shouldSecureText = false
        self.pinView.fieldBackgroundColor = UIColor.clear
        self.pinView.textColor = UIColor.Asset.white
        self.pinView.borderLineColor = UIColor.Asset.white
        self.pinView.activeBorderLineColor = UIColor.Asset.white
        self.pinView.borderLineThickness = 1
        self.pinView.activeBorderLineThickness = 1
        self.pinView.font = UIFont.asset(.bold, fontSize: .head2)
        self.pinView.keyboardType = .numberPad

        self.pinView.didChangeCallback = {[weak self] pin in
            guard let self = self else { return }
            if pin.count == 6 {
                self.pin = pin
                self.setupNextButton(isActive: true)
            } else {
                self.setupNextButton(isActive: false)
            }
        }

        self.countdownLabel.text = "Request code again \(self.secondsToTime(seconds: self.secondsRemaining)) sec"
        self.setupCountdown()
        self.setupNextButton(isActive: false)
    }

    func configCell(email: String) {
        self.subTitleLabel.text = "You will receive a 6 digit code to reset you password.  Verification code will be sent to \(email)"
    }

    private func setupNextButton(isActive: Bool) {
        self.confirmButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        if isActive {
            self.confirmButton.setTitleColor(UIColor.Asset.white, for: .normal)
            self.confirmButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.confirmButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        } else {
            self.confirmButton.setTitleColor(UIColor.Asset.gray, for: .normal)
            self.confirmButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
            self.confirmButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.black)
        }
    }

    private func secondsToTime(seconds: Int) -> String {
        let (minuteValue, secondValue) = ((seconds % 3600) / 60, (seconds % 3600) % 60)
        let minuteString =  minuteValue < 10 ? "0\(minuteValue)" : "\(minuteValue)"
        let secondString =  secondValue < 10 ? "0\(secondValue)" : "\(secondValue)"
        return "\(minuteString):\(secondString)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupCountdown() {
        self.countdownLabel.isHidden = false
        self.resendButton.isHidden = true
        self.secondsRemaining = 300
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            if self.secondsRemaining > 0 {
                self.countdownLabel.text = "Request code again \(self.secondsToTime(seconds: self.secondsRemaining)) sec"
                self.secondsRemaining -= 1
            } else {
                timer.invalidate()
                self.countdownLabel.isHidden = true
                self.resendButton.isHidden = false
            }
        }
    }

    @IBAction func confirmAction(_ sender: Any) {
        if self.pin.count == 6 {
            self.delegate?.didConfirm(self, pin: self.pin)
        }
    }

    @IBAction func resendAction(_ sender: Any) {
        self.setupCountdown()
        self.delegate?.didRequestOtp(self)
    }
}
