//
//  MergeAccountViewController.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 17/9/2564 BE.
//

import UIKit
import Core
import Defaults

class MergeAccountViewController: UIViewController {

    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var socialAvatarImage: UIImageView!
    @IBOutlet var castcleAvatarImage: UIImageView!
    @IBOutlet var socialNameLabel: UILabel!
    @IBOutlet var socialIdLabel: UILabel!
    @IBOutlet var castcleNameLabel: UILabel!
    @IBOutlet var castcleIdLabel: UILabel!
    @IBOutlet var sicialIconView: UIView!
    @IBOutlet var socialIcon: UIImageView!
    @IBOutlet var castcleIconView: UIView!
    @IBOutlet var castcleIcon: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var nextIcon: UIImageView!
    @IBOutlet var mergeButton: UIButton!
    
    var viewModel = MergeAccountViewModel(socialType: .twitter)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNavBar()
        
        self.headlineLabel.font = UIFont.asset(.regular, fontSize: .h3)
        self.headlineLabel.textColor = UIColor.Asset.white
        
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.detailLabel.textColor = UIColor.Asset.white
        self.socialNameLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.socialNameLabel.textColor = UIColor.Asset.white
        self.socialIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.socialIdLabel.textColor = UIColor.Asset.lightGray
        self.castcleNameLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.castcleNameLabel.textColor = UIColor.Asset.white
        self.castcleIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.castcleIdLabel.textColor = UIColor.Asset.lightGray
        
        self.socialAvatarImage.circle(color: UIColor.Asset.white)
        self.socialAvatarImage.image = UIImage.Asset.userPlaceholder
        self.castcleAvatarImage.circle(color: UIColor.Asset.white)
        self.castcleAvatarImage.image = UIImage.Asset.userPlaceholder
        
        self.sicialIconView.capsule(color: self.viewModel.socialType.color, borderWidth: 2, borderColor: UIColor.Asset.black)
        self.castcleIconView.capsule(color: UIColor.Asset.black, borderWidth: 2, borderColor: UIColor.Asset.black)
        self.socialIcon.image = self.viewModel.socialType.icon
        self.castcleIcon.image = UIImage.init(icon: .castcle(.logo), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.nextIcon.image = UIImage.init(icon: .castcle(.next), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        
        self.mergeButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.mergeButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.mergeButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }
    
    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "", textColor: UIColor.Asset.lightBlue)
    }
    
    @IBAction func mergeAction(_ sender: Any) {
        Utility.currentViewController().navigationController?.pushViewController(AuthenOpener.open(.enterCode(EnterCodeViewModel(verifyCodeType: .mergeAccount))), animated: true)
    }
}
