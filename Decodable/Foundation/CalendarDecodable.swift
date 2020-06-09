//
//  CalendarDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct CalendarDecodable: Decodable {
    /*
     "Calendar": {
       "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
       "Name": "Organizational Calendar",
       "Description": "This text describes the calendar",
       "Color": "#abcd12",
       "Display": 1
     },
     
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
     */
    
    let ID: String?
    let AddressID: String?
    
    let Name: String
    let Description: String
    let Color: String
    let Display: Int
    let Flags: Int?
}
