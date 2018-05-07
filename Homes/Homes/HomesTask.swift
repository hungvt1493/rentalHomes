//
//  HomesTask.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/16.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

enum HomesTask: URLRequestConvertible {
    case getAllHomes(page: Int)
    case getHome(homeId: String?)
    case createNew(title: String, desc: String, rentalType: Int, price: Int, add1: String, add2: String, add3: String, code1: Int?, code2: Int?, code3: Int?)
    case getLocationTags(searchText: String)
    case uploadFile()
    
    var method: HTTPMethod {
        switch self {
        case .getAllHomes,.getHome, .getLocationTags:
            return .get
        case .createNew:
            return .post
        case .uploadFile:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .createNew:
            return "/homes"
        case .getAllHomes(let page):
            return "/homes/\(String(describing: page))"
        case .getHome(let homeId):
            return "/home/\(String(describing: homeId))"
        case .getLocationTags(let searchText):
            let escapedString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            return "/homeTags/" + escapedString!
        case .uploadFile:
            return "/images"
        }
    }
    
    // MARK: URLStringConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try ServiceClient.genUrl(path).asURL()
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        //        if let token = Defaults[.accessToken] {
        //            request.setValue(token, forHTTPHeaderField:kHeaderAccessTokenKey)
        //        }
        
        switch self {
        case .createNew(let title, let desc, let rentalType, let price, let add1, let add2, let add3, let code1, let code2, let code3):
            var params: [String: Any]
            let userid = Defaults[.userid]!
            params = ["user": userid, "title": title, "desc": desc, "rentalType": rentalType, "price": price, "add1": add1, "add2": add2, "add3": add3, "code1": code1 ?? -1, "code2": code2 ?? -1, "code3": code3 ?? -1, "createdDate": Date().timeIntervalSince1970]
            
            request = try JSONEncoding.default.encode(request, with: params)
            break

        default:
            request = try JSONEncoding.default.encode(request, with: nil)
            break
        }
        return request
    }
}

extension DataRequest {
    static func getRentalHomesSerializer() -> DataResponseSerializer<[RentalHome]> {
        return DataResponseSerializer { request, response, data, error in
            var serviceError: ServiceError?
            var rentalHomes: [RentalHome] = [RentalHome]()
            if let data = data {
                do {
                    let jsons = try JSON(data: data, options: [.allowFragments])
                    serviceError = ServiceError.makeError(error as NSError?,
                                                          json: jsons,
                                                          statusCode: response?.statusCode)
                    if serviceError == nil {
                        for json in jsons.array! {
                            
                            let homeId = json["_id"].string!
                            
                            let userJson = json["user"].dictionaryObject
                            let user = UserModel(userId: userJson!["_id"] as! String, username: userJson!["username"] as! String, email: userJson!["email"] as! String, phoneNumber: "", company: "", address: "")
                            
                            let unixTime = (json["createdDate"].double!)
                            
                            let title = json["title"].string!
                            let desc = json["desc"].string
                            let rentalType = json["rentalType"].int
                            let price = json["price"].int
                            let status = json["status"].array?.first?.string!
                            let imagesArray = json["images"].array
                            let add1 = json["add1"].string == nil ? "" : json["add1"].string
                            let add2 = json["add2"].string == nil ? "" : json["add2"].string
                            let add3 = json["add3"].string == nil ? "" : json["add3"].string
                            let code1 = json["code1"].int
                            let code2 = json["code2"].int
                            let code3 = json["code3"].int
                            
                            var images: [ImageModelProtocol] = [ImageModelProtocol]()
                            
                            for imgJson in imagesArray! {
                                let imgId = imgJson["_id"].string!
                                let path = imgJson["path"].string!
                                let homeId = imgJson["homeId"].string!
                                
                                let imageModel = ImageModel(imageId: imgId, path: path, homeId: homeId, image: nil)
                                images.append(imageModel)
                            }
                            
                            let rentalHome = RentalHome(homeId: homeId, user: user, title: title, createdDate: unixTime, status: status!, desc: desc, rentalType: rentalType, price: price, images: images as! [ImageModel], add1: add1!, add2: add2!, add3: add3!,code1:code1!,code2:code2!,code3:code3!)
                            rentalHomes.append(rentalHome)
                        }
                    }
                } catch (let error) {
                    serviceError = ServiceError.makeError(error as NSError?,
                                                          json: nil,
                                                          statusCode: response?.statusCode)
                }
            }
            if let serviceError = serviceError {
                return .failure(serviceError)
            }
            return .success(rentalHomes)
        }
    }

    static func createNewHomeSerializer() -> DataResponseSerializer<(String, String)> {
        return DataResponseSerializer { request, response, data, error in
            var serviceError: ServiceError?
            var result: (String, String)? = nil
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
                do {
                    let json = try JSON(data: data, options: [.allowFragments])
                    serviceError = ServiceError.makeError(error as NSError?,
                                                          json: json,
                                                          statusCode: response?.statusCode)
                    if serviceError == nil {
                        if let id = json["_id"].string, let title = json["title"].string {
                            result = ("\(id)", "\(title)")
                        }
                    }
                } catch (let error) {
                    serviceError = ServiceError.makeError(error as NSError?,
                                                          json: nil,
                                                          statusCode: response?.statusCode)
                }
            }
            if let serviceError = serviceError {
                return .failure(serviceError)
            }
            
            if let result = result {
                return .success(result)
            }
            
            return .failure(ServiceError())
        }
    }
    
    static func sendFileSerializer() -> DataResponseSerializer<String> {
        return DataResponseSerializer { request, response, data, error in
            var serviceError: ServiceError?
            var result: String? = nil
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
                do {
                    let json = try JSON(data: data, options: [.allowFragments])
                    serviceError = ServiceError.makeError(error as NSError?,
                                                          json: json,
                                                          statusCode: response?.statusCode)
                    if serviceError == nil {
                        if let fileId = json["_id"].string {
                            result = fileId
                        }
                    }
                } catch (let error) {
                    serviceError = ServiceError.makeError(error as NSError?,
                                                          json: nil,
                                                          statusCode: response?.statusCode)
                }
            }
            if let serviceError = serviceError {
                return .failure(serviceError)
            }
            
            if let result = result {
                return .success(result)
            }
            
            return .failure(ServiceError())
        }
    }
    
    static func getHomeTagsSerializer() -> DataResponseSerializer<([String])> {
        return DataResponseSerializer { request, response, data, error in
            var serviceError: ServiceError?
            var result: [String]? = nil
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
                do {
                    let json = try JSON(data: data, options: [.allowFragments])
                    serviceError = ServiceError.makeError(error as NSError?,
                                                          json: json,
                                                          statusCode: response?.statusCode)
                    if serviceError == nil {
                        if let tags = json["tags"].arrayObject as? [String] {
                            result = tags
                        }
                    }
                } catch (let error) {
                    serviceError = ServiceError.makeError(error as NSError?,
                                                          json: nil,
                                                          statusCode: response?.statusCode)
                }
            }
            if let serviceError = serviceError {
                return .failure(serviceError)
            }
            
            if let result = result {
                return .success(result)
            }
            
            return .failure(ServiceError())
        }
    }
    
    @discardableResult
    func responseGetHomes(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<[RentalHome]>) -> Void) -> Self {
        return response(queue: queue,
                        responseSerializer: DataRequest.getRentalHomesSerializer(),
                        completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseCreateNewHome(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<(String, String)>) -> Void) -> Self {
        return response(queue: queue,
                        responseSerializer: DataRequest.createNewHomeSerializer(),
                        completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseGetHomeTags(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<([String])>) -> Void) -> Self {
        return response(queue: queue,
                        responseSerializer: DataRequest.getHomeTagsSerializer(),
                        completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseUploadFile(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<String>) -> Void) -> Self {
        return response(queue: queue,
                        responseSerializer: DataRequest.sendFileSerializer(),
                        completionHandler: completionHandler)
    }
}

