//
//  CreateAnEventRequestDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct CreateAnEventRequestDecodable: Decodable {
    /*
     {
        "MemberID":"wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
        "Permissions":3,
        "CalendarKeyPacket":"vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
        "CalendarEventContent":[
           {
              "Type":2,
              "Data":"BEGIN:VCALENDAR\n BEGIN:VEVENT\n...",
              "Signature":"-----BEGIN PGP SIGNATURE-----..."
           },
           {
              "Type":3,
              "Data":"0sA1AUCPgYlE77RdiJYwGVoPZ6lcn...",
              "Signature":"-----BEGIN PGP SIGNATURE-----..."
           }
        ],
        "SharedKeyPacket":"vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
        "SharedEventContent":[
           {
              "Type":2,
              "Data":"BEGIN:VCALENDAR\n BEGIN:VEVENT\n...",
              "Signature":"-----BEGIN PGP SIGNATURE-----..."
           },
           {
              "Type":3,
              "Data":"0sA1AUCPgYlE77RdiJYwGVoPZ6lcn...",
              "Signature":"-----BEGIN PGP SIGNATURE-----..."
           }
        ],
        "PersonalEventContent":{
           "Type":2,
           "Data":"BEGIN:VCALENDAR\n BEGIN:VEVENT\n BEGIN:VALARM...",
           "Signature":"-----BEGIN PGP SIGNATURE-----..."
        },
        "AttendeesEventContent":{
           "Type":3,
           "Data":"0sA1AUCPgYlE77RdiJYwGVoPZ6lcn...",
           "Signature":"-----BEGIN PGP SIGNATURE-----..."
        },
        "Attendees":[
           {
              "Token":"4b341d3fa467a10535449eec7801a0d6665882b8",
              "Permissions":1
           },
           {
              "Token":"eff38b7660211bfaffc7aab8e48b180e771f286a",
              "Permissions":6
           }
        ]
     }
     */
    
    let MemberID: String
    let Permissions: Int
    let CalendarKeyPacket: String
    let CalendarEventContent: [EventContentDecodable]
    let SharedKeyPacket: String
    let SharedEventContent: [EventContentDecodable]
    let PersonalEventContent: EventContentDecodable
    let AttendeesEventContent: EventContentDecodable
    let Attendees: [AttendeeDecodable]
}
