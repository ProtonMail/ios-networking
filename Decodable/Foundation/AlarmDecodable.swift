//
//  AlarmDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct AlarmDecodable: Decodable {
    /*
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
     
     "Alarm": {
       "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
       "EventID": "vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
       "CalendarID": "vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
       "MemberID": "vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
       "Occurrence": 1567761440,
       "Trigger": "-PT15M",
       "Action": 1
     }
     */
    let ID: String
    let EventID: String
    let CalendarID: String
    let MemberID: String
    let Occurrence: Int
    let Trigger: String
    let Action: Int
}
