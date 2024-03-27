//
//  Festival.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import Foundation

// Définition du type FestivalModel
struct FestivalModel: Decodable {
    var idFestival: Int
    var name: String
    var address: String
    var postalCode: String
    var city: String
    var country: String
    var isActive: Bool?
    var dateDebut: String
    var dateFin: String
}
