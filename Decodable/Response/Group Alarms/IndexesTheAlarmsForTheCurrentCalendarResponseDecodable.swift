//
//  IndexesTheAlarmsForTheCurrentCalendarResponseDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct IndexesTheAlarmsForTheCurrentCalendarResponseDecodable: Decodable {
    /*
     {
       "Code": 1000,
       "Alarms": [
         {
           "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
           "EventID": "vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
           "CalendarID": "vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
           "MemberID": "vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
           "Occurrence": 1567761440,
           "Trigger": "-PT15M",
           "Action": 1
         }
       ]
     }
     */
    
    let Code: Int
    let Alarms: [AlarmDecodable]
}
