//
//  GetOrUpdateUserSettingsResponseDecodable.swift
//  PMNetworking
//
//  Created by Chun-Hung Tseng on 2020/6/9.
//

import Foundation

struct GetOrUpdateUserSettingsResponseDecodable: Decodable {
    /*
     {
       "Code": 1000,
       "CalendarUserSettings": {
         "WeekStart": 2, // Monday: 1, Tuesday: 2, Wednesday: 3, Thursday: 4, Friday: 5, Saturday: 6, Sunday: 7
         "WeekLength": 0, // 7 Days: 0, 5 Days: 1
         "DisplayWeekNumber": 1, // 0: Off, 1: On
         "DateFormat": 0, // DD/MM/YYYY: 0, DD/MM/YYYY: 1, YYYY/MM/DD: 2
         "TimeFormat": 0, // 0: 24h, 1: 12h
         "AutoDetectPrimaryTimezone": 0, // 0: Off, 1: On
         "PrimaryTimezone": "Antarctica/Macquarie",
         "DisplaySecondaryTimezone": 0, // 0: Off, 1: On
         "SecondaryTimezone": null,
         "ViewPreference": 1, // DAILY: 0, WEEKLY: 1, MONTHLY: 2, YEARLY: 3, PLANNING: 4
         "DefaultCalendarID": null // or is the encrypted ID of the user's default calendar
       }
     }
     */
    let Code: Int
    let CalendarUserSettings: CalendarUserSettingsDecodable
}
