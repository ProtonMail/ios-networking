//
//  PassphraseDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct PassphraseDecodable: Decodable {
    /*
     "Passphrase": {
       "ID": "ItAfyAIbSWIaFSSwSGAB7IOerWAaI==",
       "Flags": 0,
       "MemberPassphrases": [
         {
           "MemberID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
           "Passphrase": "-----BEGIN PGP MESSAGE-----",
           "Signature": "-----BEGIN PGP SIGNATURE-----"
         }
       ]
     }
     */
    
    let ID: String
    let Flags: Int
    let MemberPassphrases: [MemberPassphraseDecodable]
}
