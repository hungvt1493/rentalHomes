//
//  CityModel.swift
//  Homes
//
//  Created by Hung Vuong on 2018/04/19.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import Foundation

public protocol CityModelProtocol: class {
    var id: Int {get}
    var name: String {get}
    var slug: String {get}
    var type: String {get}
    var nameWithType: String {get}
    var code: Int {get}
}

class CityModel: CityModelProtocol {
    var id: Int
    var name: String
    var slug: String
    var type: String
    var nameWithType: String
    var code: Int
    
    public init(id: Int, name: String, slug: String, type: String, nameWithType: String, code: Int) {
        self.id = id
        self.name = name
        self.slug = slug
        self.type = type
        self.nameWithType = nameWithType
        self.code = code
    }
}
