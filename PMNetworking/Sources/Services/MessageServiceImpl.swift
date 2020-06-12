//
//  MessageServiceImpl.swift
//  Pods
//
//  Created by Yanfeng Zhang on 5/22/20.
//

import Foundation

class MessageServiceImpl: MessageService {
    var service: APIService
    
    
    init(service: APIService) {
        self.service = service
    }
    
    func someFeature() -> String {
        //...prepare data
        //...
        //var apiClient = MessageFetchAPI(self.service)
        
    
        return ""
    }
}

//
//
//// mock for testing
//class MessageServiceMock: Service {
//    init(service: APIService) {
//        super.init(...)
//    }
//    func someFeature() -> String {
//        return "fake data"
//    }
//}
//
//
