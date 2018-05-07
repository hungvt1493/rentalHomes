//
//  LocationTask.swift
//  Homes
//
//  Created by Hung Vuong on 2018/04/20.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import Foundation

class LocationTask: NSObject {
    
    class func getCityList() -> [CityModel] {
        var cityList:[CityModel] = []
        
        let cityObjs = jsonFileToArray(fileName: "json/tinh_tp")
        for cityObj in cityObjs as! [String:Any] {
            
            let value = cityObj.value as! [String:Any]
            let code = value["code"] as! String
            let name = value["name"] as! String
            let nameWithType = value["name_with_type"] as! String
            let slug = value["slug"] as! String
            let type = value["type"] as! String
            
            let city = CityModel.init(id: Int(code)!, name: name, slug: slug, type: type, nameWithType: nameWithType, code: Int(code)!)
            cityList.append(city)
        }
        
        let sortedArray = cityList.sorted { $0.name < $1.name }
        
        return sortedArray
    }
    
    class func getStateList(filterParrentCode: Int) -> [StateModel] {
        var stateList:[StateModel] = []
        
        let stateObjs = jsonFileToArray(fileName: "json/quan_huyen")
        for stateObj in stateObjs as! [String:Any] {
            
            let value = stateObj.value as! [String:Any]
            let parentCode = value["parent_code"] as! String
            
            if filterParrentCode == -1 || Int(parentCode)! == filterParrentCode {
                let code = value["code"] as! String
                let name = value["name"] as! String
                let nameWithType = value["name_with_type"] as! String
                let slug = value["slug"] as! String
                let type = value["type"] as! String
                let path = value["path"] as! String
                let pathWithType = value["path_with_type"] as! String
                
                let state = StateModel.init(id: Int(code)!, name: name, slug: slug, type: type, nameWithType: nameWithType, path: path, pathWithType: pathWithType, code: Int(code)!, parentCode: Int(parentCode)!)
                stateList.append(state)
            }
        }
        
        let sortedArray = stateList.sorted { $0.nameWithType < $1.nameWithType }
        
        return sortedArray
    }
    
    class func getStressList(filterParrentCode: Int) -> [StressModel] {
        var stressList:[StressModel] = []
        
        let stressObjs = jsonFileToArray(fileName: "json/xa_phuong")
        for stressObj in stressObjs as! [String:Any] {
            
            let value = stressObj.value as! [String:Any]
            let parentCode = value["parent_code"] as! String
            
            if filterParrentCode == -1 || Int(parentCode)! == filterParrentCode {
                let code = value["code"] as! String
                let name = value["name"] as! String
                let nameWithType = value["name_with_type"] as! String
                let slug = value["slug"] as! String
                let type = value["type"] as! String
                let path = value["path"] as! String
                let pathWithType = value["path_with_type"] as! String
                
                let stress = StressModel.init(id: Int(code)!, name: name, slug: slug, type: type, nameWithType: nameWithType, path: path, pathWithType: pathWithType, code: Int(code)!, parentCode: Int(parentCode)!)
                stressList.append(stress)
            }
        }
        
        let sortedArray = stressList.sorted { $0.nameWithType < $1.nameWithType }
        
        return sortedArray
    }
}
