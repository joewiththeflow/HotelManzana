//
//  DateHelpers.swift
//  HotelManzana
//
//  Created by Joseph on 13/04/2020.
//  Copyright © 2020 Joseph Doogan. All rights reserved.
//

import Foundation

extension Date {
    
    // static function to enable Dates to be subtracted,
    // providing a tuple with the difference in months, days, etc. accessible by name
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    /*
    // To use the above function:
    
        let interval = Date() - updatedDate
        print(interval.day)
        print(interval.month)
        print(interval.hour)
     
    */
}
