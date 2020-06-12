//
//  MemberPassphraseDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct MemberPassphraseDecodable: Decodable {
    /*
     "MemberPassphrases": [
       {
         "MemberID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
         "Passphrase": "-----BEGIN PGP MESSAGE-----",
         "Signature": "-----BEGIN PGP SIGNATURE-----"
       }
     ]
     */
    
    let MemberID: String
    let Passphrase: String
    let Signature: String
}
