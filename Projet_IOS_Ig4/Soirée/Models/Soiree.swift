//
//  Soiree.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 19/03/2024.
//

import Foundation

/*
 model Event {
   idEvent     Int           @id @default(autoincrement())
   dateEvent   DateTime
   duration    Int
   address     String
   city        String
   postalCode  String
   country     String
   name        String
   idManager   String?
   description String?       @db.Text
   manager     User?         @relation("manager", fields: [idManager], references: [id], onDelete: SetNull)
   isPresented IsPresented[]

   @@index([idManager])
 }
 */

struct Jeu : Identifiable, Codable{
    var id: Int
    var name: String
    var description: String
    var idEvent: Int
}


struct Soiree : Identifiable, Codable{
    var id: Int
    var dateEvent: Date
    var duration: Int
    var address: String
    var city: String
    var postalCode: String
    var country: String
    var name: String
    var idManager: String?
    var description: String?
    var manager: User?
    var isPresented: [Jeu]
    enum CodingKeys: String, CodingKey {
        case id = "idEvent"
        case dateEvent
        case duration
        case address
        case city
        case postalCode
        case country
        case name
        case idManager
        case description
        case manager
        case isPresented
    }
}
