//
//  StateModel.swift
//  Homes
//
//  Created by Hung Vuong on 2018/04/19.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import Foundation

public protocol StateModelProtocol: class {
    var id: Int {get}
    var name: String {get}
    var slug: String {get}
    var type: String {get}
    var nameWithType: String {get}
    var path: String {get}
    var pathWithType: String {get}
    var code: Int {get}
    var parentCode: Int {get}
}

class StateModel: StateModelProtocol {
    var id: Int
    var name: String
    var slug: String
    var type: String
    var nameWithType: String
    var path: String
    var pathWithType: String
    var code: Int
    var parentCode: Int
    
    public init(id: Int, name: String, slug: String, type: String, nameWithType: String, path: String, pathWithType: String, code: Int, parentCode: Int) {
        self.id = id
        self.name = name
        self.slug = slug
        self.type = type
        self.nameWithType = nameWithType
        self.path = path
        self.pathWithType = pathWithType
        self.code = code
        self.parentCode = parentCode
    }
}
