//
//  CalendarSettingsDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct CalendarSettingsDecodable: Decodable {
    /*
     "CalendarSettings": {
       "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
       "CalendarID": "vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
       "DefaultEventDuration": 15,
       "DefaultEmailNotification": 1,
       "DefaultFullDayNotification": 1
     }
     */
    
    let ID: String
    let CalendarID: String
    let DefaultEventDuration: Int
    let DefaultEmailNotification: Int
    let DefaultFullDayNotification: Int
}
