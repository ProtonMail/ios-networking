//
//  GetCalendarBootstrapDataResponseDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct GetCalendarBootstrapDataResponseDecodable:Decodable {
    /*
     {
       "Code": 1000,
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
       },
       "Keys": [
         {
           "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
           "CalendarID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
           "PrivateKey": "-----BEGIN PGP PRIVATE KEY BLOCK-----...",
           "PassphraseID": "ItAfyAIbSWIaFSSwSGAB7IOerWAaI==",
           "Flags": 1
         }
       ],
       "Members": [
         {
           "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
           "Email": "andy@pm.me",
           "Permissions": 63,
           "AddressID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS=="
         }
       ],
       "CalendarSettings": {
         "ID": "wSGAB7IOerWAaIItAfyAIbSWIaFSS==",
         "CalendarID": "vuGSa1zsx0kV0jsf...ebXLCQre1H1TKkhhFxA==",
         "DefaultEventDuration": 15,
         "DefaultEmailNotification": 1,
         "DefaultFullDayNotification": 1
       }
     }
     */
    let Code: Int
    let Passphrase: PassphraseDecodable
    let Keys: [KeyDecodable]
    let Members: [MemberDecodable]
    let CalendarSettings: CalendarSettingsDecodable
}
