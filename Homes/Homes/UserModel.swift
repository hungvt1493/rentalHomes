//
//  UserModel.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/22.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import Foundation

public protocol UserModelProtocol: class {
    var userId: String { get}
    var username: String? { get}
    var email: String { get }
    var phoneNumber: String? { get }
    var company: String? { get }
    var address: String? { get }
}

open class UserModel: UserModelProtocol {
    public var userId: String
    public var username: String?
    public var email: String
    public var phoneNumber: String?
    public var company: String?
    public var address: String?
    
    public init(userId: String, username: String, email: String, phoneNumber: String, company: String?, address: String?) {
        self.userId = userId
        self.username = username
        self.email = email
        self.phoneNumber = phoneNumber
        self.company = company
        self.address = address
    }
}
