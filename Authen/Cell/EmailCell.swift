//
//  EmailCell.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 2/8/2564 BE.
//

import UIKit

class EmailCell: UICollectionViewCell {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var alertLabel: UILabel!
    @IBOutlet var emailView: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.emailView.custom(color: UIColor.Asset.darkGray, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .title)
        self.headlineLabel.textColor = UIColor.Asset.white
        self.welcomeLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.welcomeLabel.textColor = UIColor.Asset.white
        self.alertLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.alertLabel.textColor = UIColor.Asset.white
        self.loginButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.loginButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.setupNextButton(isActive: false)
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
    
    static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 500)
    }
    
    @IBAction func nextAction(_ sender: Any) {
    }
    
    @IBAction func loginAction(_ sender: Any) {
    }
}
