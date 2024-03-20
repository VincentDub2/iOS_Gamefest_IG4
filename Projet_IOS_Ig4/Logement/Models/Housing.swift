//
//  Housing.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 20/03/2024.
//

import Foundation

// Modèle pour représenter un logement.
struct Housing: Identifiable {
    var id: String = UUID().uuidString
    var address: String
    var availability: Int
    var description: String?
    var isOffering: Bool // true pour offrir, false pour demander
}
