//
//  EnterCodeViewModel.swift
//  Authen
//
//  Created by Tanakorn Phoochaliaw on 17/9/2564 BE.
//


public enum VerifyCodeType {
    case password
    case mergeAccount
}
public class EnterCodeViewModel {
    
    public var verifyCodeType: VerifyCodeType
    
    public init(verifyCodeType: VerifyCodeType) {
        self.verifyCodeType = verifyCodeType
    }
}
