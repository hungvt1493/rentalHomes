//
//  ServiceClient.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/16.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import UIKit
import Alamofire

let kHTTPBaseURL                    = "http://localhost:3000"

class ServiceClient: NSObject {
    
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    static var manager: Alamofire.SessionManager = ServiceClient.defaultManager()
    static var reachability: NetworkReachabilityManager? = NetworkReachabilityManager(host: kHTTPBaseURL)
    
    class func defaultManager() -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 60
        let manager = Alamofire.SessionManager.default
        reachability?.startListening()
        
        return manager
    }
    
    class func genUrl(_ api:String) -> String {
        return kHTTPBaseURL + api
    }
    
    class func genImageUrl(_ api:String) -> URL {
        return URL(string: kHTTPBaseURL + api)!
    }
    
    class func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return manager.request(urlRequest)
    }
    
    class func uploadFile(file: Data, toHomeId: String, urlRequest: URLRequestConvertible, completion:@escaping (_ error: ServiceError?, _ fileId: String?) -> Void) {
        manager.upload(multipartFormData: { multipartFormData in
            let imageFileName = toHomeId + ".jpg"
            multipartFormData.append(file, withName: "file", fileName: imageFileName, mimeType: "image/jpeg")
            multipartFormData.append(toHomeId.data(using: String.Encoding.utf8)!, withName: "homeId")
        }, with: urlRequest, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseUploadFile { (response) in
                    switch response.result {
                    case .success(let value):
                        completion(nil, value)
                        break
                    case .failure(let error as ServiceError):
                        completion(error, nil)
                        break
                    default:
                        break
                    }
                }
                break
            case .failure:
                completion(ServiceError(), nil)
                break
            }
        })
    }
    
//    class func uploadMultiFiles(files: [Data], urlRequest: URLRequestConvertible, completion:@escaping (_ error: ServiceError?, _ fileIds: [String]) -> Void) {
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            // import image to request
//            for imageData in files {
//                multipartFormData.append(imageData, withName: "\(imageParamName)[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
//            }
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//        }, to: urlRequest,
//
//           encodingCompletion: { encodingResult in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//
//                }
//            case .failure(let error):
//                print(error)
//            }
//
//        })
//    }
}
