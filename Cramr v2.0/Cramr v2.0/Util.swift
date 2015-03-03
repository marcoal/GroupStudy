//
//  StringManipulator.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/19/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation

var cramrBlue = UIColorFromRGB(UInt(9550335))

func getCourseID(item: String) -> String {
    var arr = split(item) {$0 == ":"}
    return arr[0]
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

