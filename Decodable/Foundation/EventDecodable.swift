//
//  EventDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct EventDecodable: Decodable {
    /*
     "Event":{
        "ID":"vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
        "CalendarID":"ziWi-ZOb28XR4sCGFCEpq...fhjBbUPDMHGU699fw==",
        "SharedEventID":"ziWi-ZOb28XR4sCGFCEpq...fhjBbUPDMHGU699fw==",
        "StartTime": 1564141942,
        "StartTimezone": "Europe/Paris",
        "EndTime": 1564142942,
        "EndTimezone": "Europe/Zurich",
        "FullDay": 0,
        "RRule": null,
        "UID":"j6-NqPWlGFqBEeyY8wPf0Pjn-2VG@proton.me",
        "RecurrenceID": null,
        "Exdates": [1567761440, 1567762440],
        "CreateTime":1564141942,
        "LastEditTime":1564141942,
        "Permissions":3,
        "CalendarKeyPacket":"vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
        "CalendarEvents":[
           {
              "Type":2,
              "Data":"BEGIN:VCALENDAR\n BEGIN:VEVENT\n...",
              "Signature":"-----BEGIN PGP SIGNATURE-----...",
              "Author":"andy@pm.me"
           },
           {
              "Type":3,
              "Data":"0sA1AUCPgYlE77RdiJYwGVoPZ6lcn...",
              "Signature":"-----BEGIN PGP SIGNATURE-----...",
              "Author":"andy@pm.me"
           }
        ],
        "SharedKeyPacket":"vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
        "SharedEvents":[
           {
              "Type":2,
              "Data":"BEGIN:VCALENDAR\n BEGIN:VEVENT\n...",
              "Signature":"-----BEGIN PGP SIGNATURE-----...",
              "Author":"andy@pm.me"
           },
           {
              "Type":3,
              "Data":"0sA1AUCPgYlE77RdiJYwGVoPZ6lcn...",
              "Signature":"-----BEGIN PGP SIGNATURE-----...",
              "Author":"andy@pm.me"
           }
        ],
        "PersonalEvents":[
           {
              "MemberID":"wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
              "Type":2,
              "Data":"BEGIN:VCALENDAR\n BEGIN:VEVENT\n BEGIN:VALARM...",
              "Signature":"-----BEGIN PGP SIGNATURE-----...",
              "Author":"andy@pm.me"
           }
        ],
        "AttendeesEvents":[
           {
              "Type":3,
              "Data":"0sA1AUCPgYlE77RdiJYwGVoPZ6lcn...",
              "Signature":"-----BEGIN PGP SIGNATURE-----...",
              "Author":"andy@pm.me"
           }
        ],
        "Attendees":[
           {
              "ID":"wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
              "Token":"4b341d3fa467a10535449eec7801a0d6665882b8",
              "Status":0,
              "Permissions":1
           },
           {
              "ID":"wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
              "Token":"eff38b7660211bfaffc7aab8e48b180e771f286a",
              "Status":2,
              "Permissions":6
           }
        ]
     }
     */
    
    let ID: String
    let CalendarID: String
    let SharedEventID: String
    
    let StartTime: Int
    let StartTimezone: String
    let EndTime: Int
    let EndTimezone: String
    
    let FullDay: Int
    let RRule: String
    
    let UID: String
    let RecurrenceID: String
    let Exdates: [Int]
    
    let CreateTime: Int
    let LastEditTime: Int
    
    let Permissions: Int
    
    let CalendarKeyPacket: String
    let CalendarEvents: [EventContentDecodable]
    let SharedKeyPacket: String
    let SharedEvents: [EventContentDecodable]
    let PersonalEvents: [EventContentDecodable]
    let AttendeesEvents: [EventContentDecodable]
    let Attendees: [AttendeeDecodable]
}
