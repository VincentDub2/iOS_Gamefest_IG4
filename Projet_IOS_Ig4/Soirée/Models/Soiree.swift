//
//  Event.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 22/03/2024.
//

import Foundation


struct Soiree: Identifiable, Decodable{
    let id: Int
    let dateEvent: Date
    let duration: Int
    let address: String
    let city: String
    let postalCode: String
    let country: String
    let name: String
    let idManager: String?
    let description: String?
    enum CodingKeys: String, CodingKey {
        case id = "idEvent"
        case dateEvent = "dateEvent"
        case duration = "duration"
        case address = "address"
        case city = "city"
        case postalCode = "postalCode"
        case country = "country"
        case name = "name"
        case idManager = "idManager"
        case description = "description"
    }
}
