//
//  MemberDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct MemberDecodable: Decodable {
    /*
     "Members": [
       {
         "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
         "Email": "andy@pm.me",
         "Permissions": 127,
         "AddressID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS=="
       }
     ]
     
     "Members": [
       {
         "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
         "Email": "andy@pm.me",
         "Permissions": 63,
         "AddressID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS=="
       }
     ],
     */
    
    let ID: String
    let Email: String
    let Permissions: Int
    let AddressID: String
}
