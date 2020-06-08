//
//  InformationPackage.swift
//  LifeCountdown
//
//  Created by Ozan Mirza on 11/6/19.
//  Copyright © 2019 Ozan Mirza. All rights reserved.
//

import Foundation 

class InformationPackage {
    static var startDate: Date!
    static var endDate: Date!
    static var name: String!
    static var created: Bool!
    
    class func export(startDate: Date!, endDate: Date!, name: String!, created: Bool!) {
        InformationPackage.startDate = startDate
        InformationPackage.endDate = endDate
        InformationPackage.name = name
        InformationPackage.created = created
    }
    
    class func pack() {
        UserDefaults.standard.set(InformationPackage.startDate, forKey: "StartDate")
        UserDefaults.standard.set(InformationPackage.endDate, forKey: "EndDate")
        UserDefaults.standard.set(InformationPackage.name, forKey: "Name")
        UserDefaults.standard.set(InformationPackage.created, forKey: "Created")
    }
    
    class func unpack() {
        InformationPackage.startDate = UserDefaults.standard.value(forKey: "StartDate") as? Date
        InformationPackage.endDate = UserDefaults.standard.value(forKey: "EndDate") as? Date
        InformationPackage.name = UserDefaults.standard.value(forKey: "Name") as? String
        InformationPackage.created = UserDefaults.standard.bool(forKey: "Created")
    }
    
    class func clear() {
        UserDefaults.standard.set(nil, forKey: "StartDate")
        UserDefaults.standard.set(nil, forKey: "EndDate")
        UserDefaults.standard.set(nil, forKey: "Name")
        UserDefaults.standard.set(nil, forKey: "Created")
    }
    
    class func getTotalHours() -> Int {
        return Calendar.current.dateComponents([.hour], from: startDate, to: endDate).hour!
    }
    
    class func getUsedHours() -> Int {
        return Calendar.current.dateComponents([.hour], from: startDate, to: Date()).hour!
    }
    
    class func getLeftHours() -> Int {
        return InformationPackage.getTotalHours() - InformationPackage.getUsedHours()
    }
    
    class func getPercentUsedHours() -> Int {
        return (InformationPackage.getUsedHours() / InformationPackage.getTotalHours()) * 100
    }
    
    class func getAngleUsedHours() -> Int {
        return (InformationPackage.getPercentUsedHours() / 100) * 360
    }
}
