//
//  EventContentDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct EventContentDecodable: Decodable {
    /*
     {
        "Type":2,
        "Data":"BEGIN:VCALENDAR\n BEGIN:VEVENT\n...",
        "Signature":"-----BEGIN PGP SIGNATURE-----..."
     }
     
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
     */
    
    let `Type`: Int
    let Data: String
    let Signature: String
    let Author: String
}
