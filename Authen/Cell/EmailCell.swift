//
//  EmailCell.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 2/8/2564 BE.
//

import UIKit
import Core
import JVFloatLabeledTextField

class EmailCell: UICollectionViewCell, UITextFieldDelegate {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var alertLabel: UILabel!
    @IBOutlet var emailView: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var emailTextField: JVFloatLabeledTextField!
    
    var viewModel = EmailViewModel()
    
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
        self.activityIndicator.color = UIColor.Asset.lightBlue
        self.activityIndicator.isHidden = true
        self.setupNextButton(isActive: false)
        
        self.checkImage.isHidden = true
        self.checkImage.tintColor = UIColor.Asset.denger
        self.emailTextField.delegate = self
        
        self.viewModel.didCheckEmailExistsFinish = {
            self.emailTextField.isEnabled = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            if self.viewModel.isEmailExist {
                self.setupNextButton(isActive: false)
                self.checkImage.isHidden = false
                self.checkImage.image = UIImage.init(icon: .castcle(.incorrect), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.denger)
                self.alertLabel.text  = Localization.RegisterCheckEmail.alertEmailInvalid.text
                self.alertLabel.textColor = UIColor.Asset.denger
                self.emailTextField.textColor = UIColor.Asset.denger
            } else {
                self.setupNextButton(isActive: true)
                self.checkImage.isHidden = false
                self.checkImage.image = UIImage.init(icon: .castcle(.checkmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
                self.alertLabel.text  = Localization.RegisterCheckEmail.alertEmailValid.text
                self.alertLabel.textColor = UIColor.Asset.lightBlue
                self.emailTextField.textColor = UIColor.Asset.white
            }
        }
    }
    
    func configCell(fromSignIn: Bool) {
        self.viewModel.framSignIn = fromSignIn
        self.headlineLabel.text = Localization.RegisterCheckEmail.headline.text
        self.welcomeLabel.text = Localization.RegisterCheckEmail.welcome.text
        self.alertLabel.text = Localization.RegisterCheckEmail.alertNotice.text
        self.nextButton.setTitle(Localization.RegisterCheckEmail.button.text, for: .normal)
        self.loginButton.setTitle(Localization.RegisterCheckEmail.alreadyAccount.text, for: .normal)
        self.emailTextField.font = UIFont.asset(.regular, fontSize: .body)
        self.emailTextField.placeholder = Localization.RegisterCheckEmail.email.text
        self.emailTextField.placeholderColor = UIColor.Asset.gray
        self.emailTextField.floatingLabelTextColor = UIColor.Asset.gray
        self.emailTextField.floatingLabelActiveTextColor = UIColor.Asset.gray
        self.emailTextField.floatingLabelFont = UIFont.asset(.regular, fontSize: .small)
        self.emailTextField.textColor = UIColor.Asset.white
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setupNextButton(isActive: false)
        self.checkImage.isHidden = true
        self.alertLabel.text  = Localization.RegisterCheckEmail.alertNotice.text
        self.alertLabel.textColor = UIColor.Asset.white
        self.emailTextField.textColor = UIColor.Asset.white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let email: String = textField.text ?? ""
        if email.isEmpty {
            self.setupNextButton(isActive: false)
            self.checkImage.isHidden = true
            self.alertLabel.text  = Localization.RegisterCheckEmail.alertNotice.text
            self.alertLabel.textColor = UIColor.Asset.white
            self.emailTextField.textColor = UIColor.Asset.white
        } else if email.isEmail {
            textField.isEnabled = false
            self.activityIndicator.isHidden = false
            self.checkImage.isHidden = true
            self.activityIndicator.startAnimating()
            self.viewModel.authenRequest.payload.email = textField.text!
            self.viewModel.checkEmailExists()
        } else {
            self.setupNextButton(isActive: false)
            self.checkImage.isHidden = false
            self.checkImage.image = UIImage.init(icon: .castcle(.incorrect), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.denger)
            self.alertLabel.text  = Localization.RegisterCheckEmail.alertWrongFormat.text
            self.alertLabel.textColor = UIColor.Asset.denger
            self.emailTextField.textColor = UIColor.Asset.denger
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if !self.viewModel.isEmailExist {
            self.endEditing(true)
            let vc = AuthenOpener.open(.createPassword) as? CreatePasswordViewController
            vc?.viewModel = CreatePasswordViewModel(authenRequest: self.viewModel.authenRequest)
            Utility.currentViewController().navigationController?.pushViewController(vc ?? CreatePasswordViewController(), animated: true)
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.endEditing(true)
        if self.viewModel.framSignIn {
            Utility.currentViewController().navigationController?.popViewController(animated: true)
        } else {
            Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.signIn(showSignUp: false)), animated: true)
        }
    }
}
