//
//  CreateNewCalendar.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

// https://gitlab.protontech.ch/ProtonMail/Slim-API/-/blob/develop/apps/Calendar/api-spec/pm_calendars_api.md
struct CreateNewCalendarRequestDecodable: Decodable {
    /*
     {
       "Name": "Organizational Calendar",
       "Description": "This text describes the calendar",
       "AddressID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
       "Color": "#abcd12",
       "Display": 1
     }
     */
    
    let Name: String
    let Description: String
    let AddressID: String
    let Color: String
    let Display: Int
}
