//
//  UserTask.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/22.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum UserTask: URLRequestConvertible {
    case login(email: String, password: String)
    case getAllUsers()
    case getMyProfile()
    case regNewUser(email: String, username: String, password: String)
    case getProfile(userId: String?)
    case logout()
    
    var method: HTTPMethod {
        switch self {
        case .getMyProfile,.getProfile, .logout, .getAllUsers:
            return .get
        case .login, .regNewUser:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .regNewUser:
            return "/register"
        case .getAllUsers:
            return "/users/all"
        case .getProfile(let userId):
            return "/users/profile/\(String(describing: userId))"
        case .getMyProfile:
            return "/users/myprofile"
        case .logout:
            return "/logout"
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
        case .login(let email, let password):
            var params: [String: Any]
            params = ["email": email, "password": password]
            request = try JSONEncoding.default.encode(request, with: params)
            break
        case .getAllUsers():
            request = try JSONEncoding.default.encode(request, with: nil)
            break
        case .getProfile(let userId):
            var params: [String: Any]
            if let userId = userId, !userId.isEmpty {
                params = ["userId": userId]
                request = try URLEncoding.default.encode(request, with: params)
            } else {
                //request = try JSONEncoding.default.encode(request, with: nil)
            }
            break
        case .regNewUser(let email, let username, let password):
            var params: [String: Any]
            params = ["email": email, "username": username, "password": password]
            
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
    static func getUserInfoSerializer() -> DataResponseSerializer<Any?> {
        return DataResponseSerializer { request, response, data, error in
            var serviceError: ServiceError?
            var user: UserModelProtocol = UserModel(userId: "", username: "", email: "", phoneNumber: "", company: "", address: "")
            if let data = data {
                do {
                    let json = try JSON(data: data, options: [.allowFragments])
                    serviceError = ServiceError.makeError(error as NSError?,
                                                          json: json,
                                                          statusCode: response?.statusCode)
                    if serviceError == nil {
                        print("JSON" + "\(json)")
                        
                        let userId = json["_id"].string
                        
                        if let userId = userId {
                            
                            let email = json["email"].string!
                            let username = json["username"].string
                            
                            user = UserModel(userId: userId, username: username!, email: email, phoneNumber: "", company: "", address: "")
                        } else {
                            let msg = json["message"].string!
                            print(msg)
                            return .success(msg)
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
            return .success(user)
        }
    }
    
    
    static func getLogoutSerializer() -> DataResponseSerializer<Bool> {
        return DataResponseSerializer { request, response, data, error in
            var serviceError: ServiceError?
            var logout = false
            if let data = data {
                do {
                    let json = try JSON(data: data, options: [.allowFragments])
                    serviceError = ServiceError.makeError(error as NSError?,
                                                          json: json,
                                                          statusCode: response?.statusCode)
                    if serviceError == nil {
                        print("JSON" + "\(json)")
                        let loggedOut = json["error"].int
                        
                        logout = (loggedOut == 0)
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
            return .success(logout)
        }
    }
    
    
    @discardableResult
    func responseUserInfo(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Any?>) -> Void) -> Self {
        return response(queue: queue,
                        responseSerializer: DataRequest.getUserInfoSerializer(),
                        completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseLogout(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Bool>) -> Void) -> Self {
        return response(queue: queue,
                        responseSerializer: DataRequest.getLogoutSerializer(),
                        completionHandler: completionHandler)
    }
}
