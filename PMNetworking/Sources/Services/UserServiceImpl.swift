//
//  UserServiceImpl.swift
//  PMNetworking
//
//  Created by Yanfeng Zhang on 5/25/20.
//

import Foundation


class UserServiceImpl: MessageService {
    var service: APIService
    
    
    init(service: APIService) {
        self.service = service
    }
    
    func someFeature() -> String {
        
        //apiClient.exec()/apiClient.ayncExec()
            // ....
        let result = self.service.exec(route: UserAPI.Router.checkUsername("tedst")) as? TestResponse
        
        
        
        return ""
    }
}


    


