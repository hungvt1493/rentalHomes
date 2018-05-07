//
//  RentalHome.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/16.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import Foundation

enum DataType {
    case text
    case number
    case date
}

public protocol RentalHomeModelProtocol: class {
    var homeId: String { get }
    var user: UserModel { get }
    var title: String { get }
    var createdDate: Double { get }
    var status: String { get }
    var desc: String? { get }
    var rentalType: Int? { get }
    var price: Int? { get }
    var images: [ImageModel] { get }
    var add1: String? { get }
    var add2: String? { get }
    var add3: String? { get }
    var code1: Int? { get }
    var code2: Int? { get }
    var code3: Int? { get }
    
    func pasreDataToDict() -> [NSDictionary]
}

class RentalHome: RentalHomeModelProtocol {
    open var homeId: String
    open var user: UserModel
    open var title: String
    open var createdDate: Double
    open var status: String
    open var desc: String?
    open var rentalType: Int?
    open var price: Int?
    open var images: [ImageModel]
    open var add1: String?
    open var add2: String?
    open var add3: String?
    open var code1: Int?
    open var code2: Int?
    open var code3: Int?
    
    public init(homeId: String, user: UserModel, title: String, createdDate: Double, status: String, desc: String?, rentalType: Int?, price: Int?, images: [ImageModel], add1: String?, add2: String?, add3: String?, code1: Int?, code2: Int?, code3: Int?) {
        self.homeId = homeId
        self.user = user
        self.title = title
        self.createdDate = createdDate
        self.status = status
        self.desc = desc
        self.rentalType = rentalType
        self.price = price
        self.images = images
        self.add1 = add1
        self.add2 = add2
        self.add3 = add3
        self.code1 = code1
        self.code2 = code2
        self.code3 = code3
    }
    
    public func pasreDataToDict() -> [NSDictionary] {
        return [
                ["title": "Title","value":checkIfStringIsEmpty(self.title),"type":DataType.text],
                ["title": "Add1","value":checkIfStringIsEmpty(self.add1),"type":DataType.text],
                ["title": "Add2","value":checkIfStringIsEmpty(self.add2),"type":DataType.text],
                ["title": "Add3","value":checkIfStringIsEmpty(self.add3),"type":DataType.text],
                ["title": "Description","value":checkIfStringIsEmpty(self.desc),"type":DataType.text],
                ["title": "Created Date","value":self.createdDate,"type":DataType.date],
                ["title": "Type","value":self.rentalType!,"type":DataType.number],
                ["title": "Price","value":self.price!,"type":DataType.number]
        ]
    }
}
