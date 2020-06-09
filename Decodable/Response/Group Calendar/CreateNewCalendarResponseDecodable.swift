//
//  CreateNewCalendarResponseDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct CreateNewCalendarResponseDecodable: Decodable {
    /*
     {
       "Code": 1000,
       "Calendar": {
         "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
         "Name": "Organizational Calendar",
         "Description": "This text describes the calendar",
         "Color": "#abcd12",
         "Display": 1
       },
       "Members": [
         {
           "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
           "Email": "andy@pm.me",
           "Permissions": 127,
           "AddressID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS=="
         }
       ]
     }
     */

    let Code: Int
    let Calendar: CalendarDecodable
    let Members: [MemberDecodable]
}
