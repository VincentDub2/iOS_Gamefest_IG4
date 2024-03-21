//
//  Housing.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 20/03/2024.
//

import Foundation

/*
db

 model Housing {
   idHousing    Int    @id @default(autoincrement())
   idUser       String
   availibility String
   description  String @db.LongText
   city         String
   postalCode   String
   country      String
isOffering   Boolean @default(true)
   user         User   @relation(fields: [idUser], references: [id], onDelete: Cascade)

   @@index([idUser])
 }

 */

var house1 = Housing(id: 1, availability: 2, idUser: "1", description: "description", isOffering: true, city: "Paris", postalCode: "75000", country: "France")

// Modèle pour représenter un logement.
struct Housing: Identifiable , Codable{
    var id: Int
    var availability: Int
    var idUser: String
    var description: String?
    var isOffering: Bool // true pour offrir, false pour demander
    var city: String
    var postalCode: String
    var country: String
    enum CodingKeys: String, CodingKey {
        case id = "idHousing"
        case availability
        case idUser
        case description
        case isOffering
        case city
        case postalCode
        case country
    
    }
    
    
}
