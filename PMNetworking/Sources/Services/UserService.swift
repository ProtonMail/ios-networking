//
//  UserService.swift
//  AFNetworking
//
//  Created by Yanfeng Zhang on 5/25/20.
//

import Foundation

// UserService
// MessageService
// ContactsService
// CalendarService
// etc
// predefind message srvice interfaces.
// doing this we can mock the service to test ViewModel
protocol UserService: Service {
    func someFeature() -> String
}
