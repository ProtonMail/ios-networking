//
//  MessageService.swift
//  Pods
//
//  Created by Yanfeng Zhang on 5/22/20.
//

import Foundation




// UserService
// MessageService
// ContactsService
// CalendarService
// etc
// predefind message srvice interfaces.
// doing this we can mock the service to test ViewModel
protocol MessageService: Service {
    func someFeature() -> String
}
