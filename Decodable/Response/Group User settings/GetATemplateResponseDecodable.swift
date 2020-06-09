//
//  GetATemplateResponseDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct GetATemplateResponseDecodable: Decodable {
    /*
     {
        "Code": 1000,
        "Template": "<http></http>"
      }
     */
    
    let Code: Int
    let Template: String
}
