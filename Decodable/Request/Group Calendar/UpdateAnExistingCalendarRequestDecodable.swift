//
//  UpdateAnExistingCalendarRequestDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct UpdateAnExistingCalendarRequestDecodable: Decodable {
    /*
     {
        "Name": "Personal Calendar",
        "Description": "This text describes the calendar",
        "Color": "#abcd12",
        "Display": 1
     }
     */
    
    let Name: String
    let Description: String
    let Color: String
    let Display: Int
}
