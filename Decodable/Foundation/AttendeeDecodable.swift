//
//  AttendeeDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct AttendeeDecodable: Decodable {
    /*
     "Attendees":[
     {
        "Token":"4b341d3fa467a10535449eec7801a0d6665882b8",
        "Permissions":1
     },
     {
        "Token":"eff38b7660211bfaffc7aab8e48b180e771f286a",
        "Permissions":6
     }
     
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
     */
    
    let ID: String?
    let Token: String
    let Permissions: Int
    let Status: Int?
}
