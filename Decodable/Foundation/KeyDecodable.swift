//
//  KeyDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct KeyDecodable: Decodable {
    /*
     "Keys": [
       {
         "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
         "CalendarID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
         "PrivateKey": "-----BEGIN PGP PRIVATE KEY BLOCK-----...",
         "PassphraseID": "ItAfyAIbSWIaFSSwSGAB7IOerWAaI==",
         "Flags": 1
       }
     ],
     */
    let ID: String
    let CalendarID: String
    let PrivateKey: String
    let PassphraseID: String
    let Flags: Int
}
