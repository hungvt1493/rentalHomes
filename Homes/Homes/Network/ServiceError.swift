import Alamofire
//import SwiftyUserDefaults
import SwiftyJSON

public struct ServiceError: Error {
    struct Code {
        struct Common {
            static let network = -1
            static let badRequest = 150
        }
    }
    
    var statusCode: Int = -1
    
    var serviceCode: Int = -1
    
    var errorCode: Int = -1
    
    var statusMessage: String = ""
    
    var serviceMessage: String = ""
    
    var isNetworkError: Bool {
        return self.serviceCode == Code.Common.network
    }
    
    public var description: String {
        get {
            return "Http code: \(self.statusCode), service code: \(self.serviceCode), status_message: \(self.statusMessage), service_message: \(self.serviceMessage)";
        }
    }
    
    var localizedFailureReason: String {
        if self.isNetworkError {
            return LocStr("MSG_001")
        }
        
        if self.serviceMessage != "" {
            return self.serviceMessage
        }
        
        return LocStr("unknown_error")
    }
    
    var nsError: NSError {
        get {
            return NSError(domain: "KonnectPlus", code: self.serviceCode, userInfo: [NSLocalizedFailureReasonErrorKey: self.localizedFailureReason])
        }
    }
    
    public static func makeError(_ error: NSError?, json: JSON?, statusCode: Int?) -> ServiceError? {
        var serviceError: ServiceError?
        
        if let error = error {
            serviceError = ServiceError()
            serviceError?.errorCode = error.code
            if let statusCode = statusCode {
                serviceError?.statusCode = statusCode
            }
            serviceError?.serviceCode = Code.Common.network
            serviceError?.statusMessage = error.localizedDescription
        }
        
        if let serviceCode = json?["error"].int, serviceCode > 0 {
            if serviceError == nil {
                serviceError = ServiceError()
                if let statusCode = statusCode {
                    serviceError?.statusCode = statusCode
                }
            }
            
            serviceError?.serviceCode = serviceCode
            
            if let serviceMessage = json?["error_msg"].string {
                serviceError?.serviceMessage = serviceMessage
            }
        }
        
        return serviceError
    }
    
}
