//
//  StringManipulator.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/19/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import SystemConfiguration

var cramrBlue = UIColorFromRGB(UInt(9550335))

var cramrEggshell = UIColorFromRGB(UInt(14543615))

var cramrPurple = UIColorFromRGB(UInt(10061055))

var cramrAqua = UIColorFromRGB(UInt(8712703))




func getCourseID(item: String) -> String {
    var arr = split(item) {$0 == ":"}
    return arr[0]
}

func getShortName(longName: String) -> String{
    var name = ""
    if longName != "" {
        var arr = split(longName) {$0 == " "}
        name = arr[0]
        if arr.count > 1 {
            var firstCharLastName = Array(arr[arr.count-1])[0]
            name += " " + [firstCharLastName] + "."
        }
    }
    return name
}

func getCourseName(item: String) -> String {
    var arr = split(item) {$0 == ":"}
    return arr[1]
}

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func convertToSessionDict(sessionID: String, description: String, location: String, courseName: String, latitude: String, longitude: String ) -> [String: String] {
    return ["sessionID": sessionID, "description": description, "location": location, "course": courseName, "latitude": latitude, "longitude": longitude]
}

func areEqualSessions(first: [String: String], second: [String: String]) -> Bool {
    return first["description"] == second["description"] && first["sessionID"] == second["sessionID"] && first["course"] == second["course"]
}


func addBlur(superView : UIView, subViews : [UIView]) {
    
    var frame = CGRect()
    var center = CGPoint(x: 0.0, y: 0.0)
    var width = CGFloat(0.0)
    var height = CGFloat(0.0)
    
    for var i = 0; i < subViews.count; i++ {
        
        width = subViews[i].frame.width
        var temp = CGFloat(subViews[i].frame.height)
        height += temp
        
        center.x += subViews[i].center.x
        center.y += subViews[i].center.y
    }
    
    frame = CGRectMake(0, 0, width, height)
    
    center.x = center.x / CGFloat(subViews.count)
    center.y = center.y / CGFloat(subViews.count)
    
    // Blur Effect
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
    var blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = frame
    blurEffectView.center = center
    
    // Tint Effect
    var tintView = UIView()
    tintView.frame = frame
    tintView.center = center
    tintView.backgroundColor = cramrAqua
    tintView.alpha = 0.35
    
    // Vibrancy effect
    // var vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
    // var vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
    // vibrancyEffectView.frame = frame
    
    
    blurEffectView.layer.borderWidth = 1.0
    blurEffectView.layer.borderColor = cramrBlue.CGColor
    // Todo
    //superView.addSubview(tintView)
    
    superView.addSubview(blurEffectView)
    
    for subView in subViews {
        //For Vibrancy
        //vibrancyEffectView.contentView.addSubview(subView)
        
        superView.bringSubviewToFront(subView)
    }
    
    //For Vibrancy
    //blurEffectView.contentView.addSubview(vibrancyEffectView)
    //superView.addSubview(blurEffectView)
}