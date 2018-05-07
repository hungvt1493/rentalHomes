//
//  LocationServices.swift
//  Homes
//
//  Created by Hung Vuong on 2018/02/27.
//  Copyright © 2018年 Hung Vuong. All rights reserved.
//

import Foundation
import MapKit

typealias JSONDictionary = [String:Any]

class LocationServices {
    
    public static let shared = LocationServices()
    let locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    
    func getAdress(completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
        
        self.locManager.requestWhenInUseAuthorization()
        
        if self.authStatus == inUse || self.authStatus == always {
            
            self.currentLocation = locManager.location
            
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(self.currentLocation) { placemarks, error in
                
                if let e = error {
                    
                    completion(nil, e)
                    
                } else {
                    
                    let placeArray = placemarks
                    
                    var placeMark: CLPlacemark!
                    
                    placeMark = placeArray?[0]
                    
                    guard let address = placeMark.addressDictionary as? JSONDictionary else {
                        return
                    }
                    
                    completion(address, nil)
                    
                }
                
            }
            
        }
        
    }
    
    
    // MARK: Used:
    /*
     LocationServices.shared.getAdress { address, error in
     
        if let a = address, let city = a["City"] as? String {
        //
        }
     }
     */
}
