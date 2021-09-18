//
//  MergeAccountViewModel.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 17/9/2564 BE.
//

import UIKit

public enum SocialType {
    case telegram
    case facebook
    case twitter
    case google
    case apple
    
    var icon: UIImage {
        switch self {
        case .telegram:
            return UIImage.init(icon: .castcle(.direct), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        case .facebook:
            return UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        case .twitter:
            return UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        case .google:
            return UIImage.Asset.googleLogo
        case .apple:
            return UIImage.init(icon: .castcle(.apple), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        }
    }
    
    var color: UIColor {
        switch self {
        case .telegram:
            return UIColor.Asset.telegram
        case .facebook:
            return UIColor.Asset.facebook
        case .twitter:
            return UIColor.Asset.twitter
        case .google:
            return UIColor.Asset.white
        case .apple:
            return UIColor.Asset.apple
        }
    }
}

public class MergeAccountViewModel {
    
    public var socialType: SocialType
    
    public init(socialType: SocialType) {
        self.socialType = socialType
    }
}
