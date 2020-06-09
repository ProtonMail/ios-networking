//
//  GetCalendarsResponseDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct GetCalendarsResponseDecodable: Decodable {
    /*
     {
       "Code": 1000,
       "Calendars": [
         {
           "Name": "Organizational Calendar",
           "Description": "This text describes the calendar",
           "AddressID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
           "Color": "#abcd12",
           "Display": 1,
           "Flags": 1
         },
         {
           "Name": "Calendar to be reset :)",
           "Description": "This text describes the calendar",
           "AddressID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
           "Color": "#abcd12",
           "Display": 1,
           "Flags": 4
         }
       ]
     }
     */
    
    let Code: Int
    let Calendars: [CalendarDecodable]
}
