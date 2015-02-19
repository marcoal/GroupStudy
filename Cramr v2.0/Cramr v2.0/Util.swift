//
//  StringManipulator.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/19/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation


func getCourseID(item: String) -> String {
    var arr = split(item) {$0 == ":"}
    return arr[0]
}

func getCourseName(item: String) -> String {
    var arr = split(item) {$0 == ":"}
    return arr[1]
}
