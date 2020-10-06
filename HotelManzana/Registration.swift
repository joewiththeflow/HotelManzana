//
//  Registration.swift
//  HotelManzana
//
//  Created by Joseph on 09/04/2020.
//  Copyright © 2020 Joseph Doogan. All rights reserved.
//

import Foundation



struct Registration: Equatable, Codable {
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("registrations").appendingPathExtension("plist")
    
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var roomType: RoomType
    var wifi: Bool
    
    static func ==(lhs: Registration, rhs: Registration) -> Bool {
        return lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.emailAddress == rhs.emailAddress &&
            lhs.checkInDate == rhs.checkInDate &&
            lhs.checkOutDate == rhs.checkOutDate &&
            lhs.numberOfAdults == rhs.numberOfAdults &&
            lhs.numberOfChildren == rhs.numberOfChildren &&
            lhs.roomType == rhs.roomType &&
            lhs.wifi == rhs.wifi
    }
    
    static func saveToFile(registrations: [Registration]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedRegistrations = try? propertyListEncoder.encode(registrations)
        try? encodedRegistrations?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [Registration]? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: archiveURL) {
            let decodedRegistrations = try? propertyListDecoder.decode(Array<Registration>.self, from: retrievedData)
            return decodedRegistrations
        }
        return nil
    }
    
    static func loadSampleRegistrations() -> [Registration] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let registrations = [
            Registration(firstName: "Joe", lastName: "Bloggs", emailAddress: "joe@bloggs.com", checkInDate: dateFormatter.date(from: "2020-04-15")!, checkOutDate: dateFormatter.date(from: "2020-04-28")!, numberOfAdults: 2, numberOfChildren: 2, roomType: RoomType.all[0], wifi: true),
        Registration(firstName: "John", lastName: "Doe", emailAddress: "john@doe.com", checkInDate: dateFormatter.date(from: "2020-04-16")!, checkOutDate: dateFormatter.date(from: "2020-04-18")!, numberOfAdults: 2, numberOfChildren: 0, roomType: RoomType.all[1], wifi: false),
        Registration(firstName: "Humphrey", lastName: "Bogart", emailAddress: "humphrey@bogart.com", checkInDate: dateFormatter.date(from: "2020-05-03")!, checkOutDate: dateFormatter.date(from: "2020-05-10")!, numberOfAdults: 1, numberOfChildren: 3, roomType: RoomType.all[2], wifi: true)
        ]
        
        return registrations
    }
}


