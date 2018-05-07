//
//  ImageModel.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/20.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit

public protocol ImageModelProtocol: class {
    var imageId: String { get set }
    var url: URL { get }
    var homeId: String { get }
    var image: UIImage? { get }
}

open class ImageModel: ImageModelProtocol {
    public var imageId: String
    public let url: URL
    public let homeId: String
    public let image: UIImage?
    public init(imageId: String, path: String, homeId: String, image: UIImage?) {
        self.imageId = imageId
        self.url = ServiceClient.genImageUrl(path)
        self.homeId = homeId
        self.image = image
    }
}
